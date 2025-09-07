package usecase

import (
	"context"
	"errors"
	"fmt"
	"strconv"

	// "log"

	domain "github.com/abrshodin/ethio-fb-backend/Domain"
	repository "github.com/abrshodin/ethio-fb-backend/Repository"
)

type TeamUsecases interface {
	GetTeam(ctx context.Context, teamId string) (*domain.Team, error)
	AddTeam(ctx context.Context, team *domain.Team) error
	Statistics(ctx context.Context, league, season int, team string) (*domain.TeamComparison, error)
	StatisticsByID(ctx context.Context, league, season, team int) (*domain.TeamComparison, error)
	GetTeamByID(ctx context.Context, teamID int) (*domain.Team, error)
	FetchAndCacheTeams(ctx context.Context, leagueID, season int) error
}

func NewTeamUsecase(repo domain.IRedisRepo, api domain.IAPIService) TeamUsecases {
	return &TeamUsecase{teamRepo: repo, api: api}
}

type TeamUsecase struct {
	teamRepo domain.IRedisRepo
	api      domain.IAPIService
}

func (tu *TeamUsecase) GetTeam(ctx context.Context, teamId string) (*domain.Team, error) {
	return tu.teamRepo.Get(ctx, teamId)
}

func (tu *TeamUsecase) AddTeam(ctx context.Context, team *domain.Team) error {
	return tu.teamRepo.Add(ctx, team)
}

func (tu *TeamUsecase) Statistics(ctx context.Context, league, season int, team string) (*domain.TeamComparison, error) {

	teamID, err := tu.teamRepo.GetID(ctx, team)
	if err != nil {
		fmt.Println("error in statistics while reading data from redis")
		return nil, domain.ErrInternalServer
	}

	if stats, err := tu.teamRepo.GetTeamStats(ctx, teamID); err == nil && stats != nil {
		return stats, nil
	}

	stats, err := tu.api.Statistics(league, season, teamID)
	if err != nil {
		return nil, err
	}
	
	_ = tu.teamRepo.SaveTeamStats(ctx, teamID, stats)

	return stats, nil
}



func( tu *TeamUsecase) StatisticsByID(ctx context.Context, league, season, team int) (*domain.TeamComparison, error){

	if stats, err := tu.teamRepo.GetTeamStats(ctx, team); err == nil && stats != nil {
		return stats, nil
	}

	stats, err := tu.api.Statistics(league, season, team)
	if err != nil {
		return nil, err
	}

	_ = tu.teamRepo.SaveTeamStats(ctx, team, stats)

	return stats, nil

}

func (tu *TeamUsecase) GetTeamByID(ctx context.Context, teamID int) (*domain.Team, error) {
	team, err := tu.teamRepo.GetTeamByID(ctx, teamID)
	if err == nil {
		return team, nil
	}
	leagues := []int{363, 39} // ETH and EPL
	seasons := []int{2021, 2022, 2023}

	for _, leagueID := range leagues {
		for _, season := range seasons {
			teamsResp, err := tu.api.GetTeams(leagueID, season)
			if err != nil {
				continue
			}

			// Convert API response to domain teams and cache them
			var teams []domain.Team
			for _, teamResp := range teamsResp.Response {
				team := domain.Team{
					ID:       strconv.Itoa(teamResp.Team.ID),
					Name:     teamResp.Team.Name,
					Short:    "",
					League:   getLeagueName(leagueID),
					CrestURL: teamResp.Team.Logo,
					Bio:      fmt.Sprintf("Founded: %d, Country: %s", getFoundedYear(teamResp.Team.Founded), teamResp.Team.Country),
				}
				teams = append(teams, team)
			}

			// Cache all teams
			tu.teamRepo.SaveAllTeams(ctx, leagueID, season, teams)

			// Check if our team is in this league/season combination
			for _, team := range teams {
				if team.ID == strconv.Itoa(teamID) {
					return &team, nil
				}
			}
		}
	}

	return nil, domain.ErrTeamNotFound
}

func (tu *TeamUsecase) FetchAndCacheTeams(ctx context.Context, leagueID, season int) error {
	teamsResp, err := tu.api.GetTeams(leagueID, season)
	if err != nil {
		return err
	}

	// Convert API response to domain teams
	var teams []domain.Team
	for _, teamResp := range teamsResp.Response {
		team := domain.Team{
			ID:       strconv.Itoa(teamResp.Team.ID),
			Name:     teamResp.Team.Name,
			Short:    "",
			League:   getLeagueName(leagueID),
			CrestURL: teamResp.Team.Logo,
			Bio:      fmt.Sprintf("Founded: %d, Country: %s", getFoundedYear(teamResp.Team.Founded), teamResp.Team.Country),
		}
		teams = append(teams, team)
		fmt.Print("name:", team.Name)
		fmt.Print("ID:", team.ID)
		tu.teamRepo.CacheTeamID(ctx, team.Name, team.ID)
	}

	// Cache all teams
	return tu.teamRepo.SaveAllTeams(ctx, leagueID, season, teams)
}


// Helper functions
func getLeagueName(leagueID int) string {
	switch leagueID {
	case 363:
		return "Ethiopian Premier League"
	case 39:
		return "English Premier League"
	default:
		return "Unknown League"
	}
}

func getFoundedYear(founded *int) int {
	if founded != nil {
		return *founded
	}
	return 0
}

type FixtureUsecase interface {
	GetFixtures(ctx context.Context, league, team, season, from, to string) ([]domain.Fixture, error)
}

type fixtureUsecase struct {
	repo  repository.FixtureRepo
	cache repository.FixtureRepo
}

func NewFixtureUsecase(r repository.FixtureRepo, c repository.FixtureRepo) FixtureUsecase {
	return &fixtureUsecase{
		repo:  r,
		cache: c,
	}
}

func (uc *fixtureUsecase) GetFixtures(ctx context.Context, league, team, season, from, to string) ([]domain.Fixture, error) {
	if league == "" {
		return nil, errors.New("league is required")
	}

	// Try cache first
	fixtures, err := uc.cache.GetFixtures(league, team, season, from, to)
	if err == nil && len(fixtures) > 0 {
		fmt.Printf("Cache hit for fixtures (league=%s, team=%s, season=%s, from=%s, to=%s)\n", league, team, season, from, to)
		return fixtures, nil
	}

	fmt.Printf("Cache miss for fixtures (league=%s, team=%s, season=%s, from=%s, to=%s), fetching from API\n", league, team, season, from, to)

	// Fallback to API repo
	fixtures, err = uc.repo.GetFixtures(league, team, season, from, to)
	if err != nil {
		fmt.Printf("API fetch failed (league=%s, team=%s, season=%s, from=%s, to=%s): %v\n", league, team, season, from, to, err)
		return nil, err
	}

	if fixtures == nil {
		return []domain.Fixture{}, nil
	}

	// Cache the results for future requests
	if apiRepo, ok := uc.cache.(*repository.APIRepo); ok && apiRepo.RDB != nil {
		if err := apiRepo.SetFixturesCache(league, team, season, from, to, fixtures); err != nil {
			fmt.Printf("Failed to cache fixtures: %v\n", err)
		} else {
			fmt.Printf("Successfully cached fixtures for (league=%s, team=%s, season=%s, from=%s, to=%s)\n", league, team, season, from, to)
		}
	}

	return fixtures, nil
}

type AnswerUsecase interface {
	Compose(ctx context.Context, context domain.AnswerContext) (*domain.Answer, error)
}
