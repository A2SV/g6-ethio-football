package infrastructure

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"os"
	"strconv"
	"time"

	domain "github.com/abrshodin/ethio-fb-backend/Domain"
	"github.com/redis/go-redis/v9"
)

// RedisConnect creates and returns a redis client using env vars
func RedisConnect() *redis.Client {
	ctx := context.Background()
	redisAddress := os.Getenv("REDIS_ADDRESS")
	redisUsername := os.Getenv("REDIS_USERNAME")
	redisPassword := os.Getenv("REDIS_PASSWORD")

	rdb := redis.NewClient(&redis.Options{
		Addr:     redisAddress,
		Username: redisUsername,
		Password: redisPassword,
		DB:       0,
	})

	// smoke-set (non-fatal)
	err := rdb.Set(ctx, "ethiofb:ping", "pong", 10*time.Second).Err()

	if err != nil {
		panic(err)
	}

	return rdb
}

// FetchFixturesFromAPI calls API-Football and returns Fixture structs for Repository layer.
//
// Accepts:
//
//	league: either "EPL" (will map to 46) or "ETH" (will map to 363) or a numeric league id string
//	team: optional team id (numeric string) — names are NOT searched here
//	from,to: optional dates in YYYY-MM-DD
//
// Returns error if API key missing or upstream error.
func FetchFixturesFromAPI(league, team, season, from, to string) ([]domain.Fixture, error) {
	apiKey := os.Getenv("API_SPORTS_API_KEY")
	if apiKey == "" {
		return nil, fmt.Errorf("missing API_FOOTBALL_KEY in .env")
	}

	// Resolve league param: allow "EPL" -> 39, "ETH" -> 363, numeric IDs as passed
	leagueID := 0
	if league == "EPL" {
		leagueID = 39
	} else if league == "ETH" {
		leagueID = 363
	} else {
		// try numeric
		if n, err := strconv.Atoi(league); err == nil {
			leagueID = n
		} else {
			return nil, fmt.Errorf("unknown league code: %s (use 'EPL', 'ETH', or numeric league id)", league)
		}
	}

	base := "https://v3.football.api-sports.io"
	endpoint := "/fixtures"
	params := url.Values{}
	params.Set("league", strconv.Itoa(leagueID))
	
	// season optional; API often needs season for historical queries; leaving unset uses API default/current
	if from != "" {
		params.Set("from", from) // YYYY-MM-DD
	}
	if to != "" {
		params.Set("to", to)
	}
	if season != "" {
		params.Set("season", season)
	}

	if team != "" {
		// allow numeric team id only
		if _, err := strconv.Atoi(team); err == nil {
			params.Set("team", team)
		}
	}

	u := fmt.Sprintf("%s%s?%s", base, endpoint, params.Encode())

	req, err := http.NewRequest(http.MethodGet, u, nil)
	if err != nil {
		return nil, err
	}
	req.Header.Set("x-rapidapi-key", apiKey)
	req.Header.Set("x-rapidapi-host", "v3.football.api-sports.io")
	// optional: req.Header.Set("Accept", "application/json")

	client := &http.Client{Timeout: 12 * time.Second}
	res, err := client.Do(req)
	if err != nil {
		return nil, err
	}
	defer res.Body.Close()

	// propagate upstream errors to caller
	if res.StatusCode >= 400 {
		b, _ := io.ReadAll(res.Body)
		return nil, fmt.Errorf("api error %d: %s", res.StatusCode, string(b))
	}

	b, err := io.ReadAll(res.Body)
	if err != nil {
		return nil, err
	}

	fmt.Println(string(b))

	// Use the specific FixturesAPIResponse for fixtures endpoint
	var apiResp domain.FixturesAPIResponse
	if err := json.Unmarshal(b, &apiResp); err != nil {
		fmt.Printf("Failed to unmarshal API response: %v\n", err)
		return nil, fmt.Errorf("failed to unmarshal API response: %w", err)
	}

	fmt.Println("api Response :", apiResp)



	fixtures := []domain.Fixture{}
	now := time.Now().UTC().Format(time.RFC3339)

	for _, r := range apiResp.Response {
		fixture := domain.Fixture{
			ID:           r.Fixture.Date,
			DateUTC:      r.Fixture.Date,
			HomeName:      r.Teams.Home.Name,
			AwayName:      r.Teams.Away.Name,
			Status:      	"scheduled",
			HomeLogo:    r.Teams.Home.Logo,
			AwayLogo:    r.Teams.Away.Logo,
			LastUpdated: now,
		}

		fixtures = append(fixtures, fixture)
	}

	
	return fixtures, nil
}
