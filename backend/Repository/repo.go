package repository

import (
	"context"
	"encoding/json"
	"fmt"
	"strconv"
	"time"

	domain "github.com/abrshodin/ethio-fb-backend/Domain"
	infrastructure "github.com/abrshodin/ethio-fb-backend/Infrastructure"
	"github.com/redis/go-redis/v9"
)

func NewTeamRepo(rdb *redis.Client) domain.IRedisRepo {
	return &teamRepo{rdb: rdb}
}

type teamRepo struct {
	rdb *redis.Client
}

func (tr *teamRepo) Get(ctx context.Context, teamId string) (*domain.Team, error) {

	key := "team" + teamId
	vals, err := tr.rdb.HGetAll(ctx, key).Result()
	if err != nil {
		return nil, domain.ErrInternalServer
	}

	if len(vals) == 0 {
		return nil, domain.ErrTeamNotFound
	}

	team := &domain.Team{
		ID:       vals["id"],
		Name:     vals["name"],
		Short:    vals["short"],
		League:   vals["league"],
		CrestURL: vals["crest_url"],
		Bio:      vals["bio"],
	}
	return team, nil
}

func (tr *teamRepo) Add(ctx context.Context, team *domain.Team) error {
	key := "team:" + team.ID
	exists, err := tr.rdb.Exists(ctx, key).Result()
	if err != nil {
		return domain.ErrInternalServer
	}

	if exists > 0 {
		return domain.ErrDuplicateFound
	}

	err = tr.rdb.HSet(ctx, key, map[string]interface{}{
		"ID":        team.ID,
		"name":      team.Name,
		"short":     team.Short,
		"league":    team.League,
		"crest_url": team.CrestURL,
		"bio":       team.Bio,
	}).Err()

	if err != nil {
		return domain.ErrInternalServer
	}

	return nil
}

func (tr *teamRepo) GetID(ctx context.Context, team string) (int, error) {

	val, err := tr.rdb.Get(ctx, team).Result()
	if err != nil {
		return 0, domain.ErrTeamNotFound
	}

	id, err := strconv.Atoi(val)
	if err != nil {
		return 0, domain.ErrInternalServer
	}

	return id, nil
}

// FixtureRepo abstracts fixture fetching
type FixtureRepo interface {
	GetFixtures(league, team, season, from, to string) ([]domain.Fixture, error)
}

// APIRepo fetches fixtures from API and caches in Redis
type APIRepo struct {
	RDB *redis.Client // exported for usecase
}

// NewAPIRepo returns a repo with optional Redis caching
func NewAPIRepo(rdb *redis.Client) *APIRepo {
	return &APIRepo{RDB: rdb}
}

func cacheKey(league, team, season, from, to string) string {
	return fmt.Sprintf("fixtures:%s:%s:%s:%s:%s", league, team, season, from, to)
}

func (r *APIRepo) GetFixtures(league, team, season, from, to string) ([]domain.Fixture, error) {
	ctx := context.Background()

	// Try cache first
	if r.RDB != nil {
		if raw, err := r.RDB.Get(ctx, cacheKey(league, team, season, from, to)).Result(); err == nil {
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
	if r.RDB != nil {
		if b, err := json.Marshal(fixtures); err == nil {
			_ = r.RDB.Set(ctx, cacheKey(league, team, season, from, to), b, 5*time.Minute).Err()
		}
	}

	return fixtures, nil
}

// SetFixturesCache manually writes fixtures to cache (optional)
func (r *APIRepo) SetFixturesCache(league, team, season, from, to string, fixtures []domain.Fixture) error {
	if r.RDB == nil {
		return nil
	}

	ctx := context.Background()
	data, err := json.Marshal(fixtures)
	if err != nil {
		return err
	}
	return r.RDB.Set(ctx, cacheKey(league, team, season, from, to), data, 5*time.Minute).Err()
}
