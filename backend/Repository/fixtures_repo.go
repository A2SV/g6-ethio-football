package repository

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	domain "github.com/abrshodin/ethio-fb-backend/Domain"
	infrastructure "github.com/abrshodin/ethio-fb-backend/Infrastructure"
	"github.com/redis/go-redis/v9"
)

type IFixturesRepo interface {
	SaveFixturesByRound(ctx context.Context, q domain.RoundQuery, fixtures []domain.PrevFixtures) error
	SaveRoundWindow(ctx context.Context, q domain.RoundQuery) error
	GetFixturesByRound(ctx context.Context, q domain.RoundQuery) (*[]domain.PrevFixtures, error)
	GetRoundWindow(ctx context.Context, q domain.RoundQuery) (from string, to string, err error)
	GetFixtures(league, team, season, from, to string) ([]domain.Fixture, error)
}

func NewPrevFixturesRepo(rdb *redis.Client) IFixturesRepo {
	return &FixturesRepo{rdb: rdb}
}

type FixturesRepo struct {
	rdb *redis.Client
}

// Key -> "pf:{league}:{season}:{round}"
func (p *FixturesRepo) SaveFixturesByRound(ctx context.Context, q domain.RoundQuery, fixtures []domain.PrevFixtures) error {
	key := fmt.Sprintf("pf:%s:%d:%s", q.League, q.Season, q.Round)
	payload, err := json.Marshal(fixtures)
	if err != nil {
		return err
	}

	if err := p.rdb.Set(ctx, key, payload, 0).Err(); err != nil {
		return err
	}
	return nil
}

// key -> "{league:season:round}" -> {from,to}
func (p *FixturesRepo) SaveRoundWindow(ctx context.Context, q domain.RoundQuery) error {
	key := fmt.Sprintf("%s:%d:%s", q.League, q.Season, q.Round)

	value := map[string]string{
		"from": q.From,
		"to":   q.To,
	}

	payload, err := json.Marshal(value)
	if err != nil {
		return err
	}

	if err := p.rdb.Set(ctx, key, payload, 0).Err(); err != nil {
		return err
	}
	return nil
}

// key -> "pf:{league}:{season}:{round}"
func (p *FixturesRepo) GetFixturesByRound(ctx context.Context, q domain.RoundQuery) (*[]domain.PrevFixtures, error) {
	key := fmt.Sprintf("pf:%s:%d:%s", q.League, q.Season, q.Round)
	raw, err := p.rdb.Get(ctx, key).Bytes()
	if err != nil {
		if err == redis.Nil {
			return nil, err
		}
		return nil, err
	}
	var fixtures []domain.PrevFixtures
	if err := json.Unmarshal(raw, &fixtures); err != nil {
		return nil, err
	}
	return &fixtures, nil
}

func (p *FixturesRepo) GetRoundWindow(ctx context.Context, q domain.RoundQuery) (string, string, error) {
	key := fmt.Sprintf("%s:%d:%s", q.League, q.Season, q.Round)
	raw, err := p.rdb.Get(ctx, key).Bytes()
	if err != nil {
		return "", "", err
	}
	var v struct {
		From string `json:"from"`
		To   string `json:"to"`
	}
	if err := json.Unmarshal(raw, &v); err != nil {
		return "", "", err
	}
	return v.From, v.To, nil
}

func (r *FixturesRepo) GetFixtures(league, team, season, from, to string) ([]domain.Fixture, error) {
	ctx := context.Background()

	// Try cache first
	if r.rdb != nil {
		if raw, err := r.rdb.Get(ctx, cacheKey(league, team, season, from, to)).Result(); err == nil {
			var cached []domain.Fixture
			if err := json.Unmarshal([]byte(raw), &cached); err == nil {
				return cached, nil
			}
			// continue if unmarshal fails
		}
	}

	// Fetch from API
	fixtures, err := infrastructure.FetchFixturesFromAPI(league, team, season, from, to)
	if err != nil {
		return []domain.Fixture{}, nil
	}

	// Cache result for 5 minutes (best-effort)
	if r.rdb != nil {
		if b, err := json.Marshal(fixtures); err == nil {
			_ = r.rdb.Set(ctx, cacheKey(league, team, season, from, to), b, 7 * 24 * time.Hour).Err()
		}
	}

	return fixtures, nil
}
