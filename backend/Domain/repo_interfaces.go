package domain

import (
	"context"
)

type IRedisRepo interface {
	Get(ctx context.Context, teamId string) (*Team, error)
	Add(ctx context.Context, team *Team) error
	GetID(ctx context.Context, leagueID string) (int, error)
	GetTeamByID(ctx context.Context, teamID int) (*Team, error)
	SaveTeamByID(ctx context.Context, teamID int, team *Team) error
	GetAllTeams(ctx context.Context, leagueID, season int) ([]Team, error)
	SaveAllTeams(ctx context.Context, leagueID, season int, teams []Team) error
	GetTeamStats(ctx context.Context, teamID int) (*TeamComparison, error)
	SaveTeamStats(ctx context.Context, teamID int, stats *TeamComparison) error
	CacheTeamID(ctx context.Context, teamName string, teamID string) error
}

type IStandingsRepo interface {
	GetStandings(ctx context.Context, leagueID, season int) (*StandingsResponse, error)
	SaveStandings(ctx context.Context, leagueID, season int, standings *StandingsResponse) error
	GetStandingsFromCache(ctx context.Context, leagueID, season int) (*StandingsResponse, error)
}

type IAPIService interface {
	PrevFixtures(leagueID int, season int, fromDate, toDate string) (*[]PrevFixtures, error)
	LiveFixtures(league string) (*[]PrevFixtures, error)
	Statistics(league, season, team int) (*TeamComparison, error)
	GetTeams(leagueID, season int) (*TeamsAPIResponse, error)
}
