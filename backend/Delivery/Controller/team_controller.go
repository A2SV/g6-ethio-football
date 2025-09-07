package controller

import (
	"fmt"
	"net/http"
	"strconv"

	domain "github.com/abrshodin/ethio-fb-backend/Domain"
	usecase "github.com/abrshodin/ethio-fb-backend/Usecase"
	"github.com/gin-gonic/gin"
)

type TeamController struct {
	teamUsecase usecase.TeamUsecases
}

func NewTeamController(teamUsecase usecase.TeamUsecases) *TeamController {
	return &TeamController{teamUsecase: teamUsecase}
}

func (tc *TeamController) GetTeam(c *gin.Context) {

	idStr := c.Param("id")
	ctx := c.Request.Context()

	// Convert string ID to int
	teamID, err := strconv.Atoi(idStr)
	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"error": "invalid team ID format"})
		return
	}

	// First try to get from cache, then from API if not found
	team, err := tc.teamUsecase.GetTeamByID(ctx, teamID)
	if err != nil {
		c.IndentedJSON(http.StatusNotFound, gin.H{"error": "team not found"})
		return
	}

	c.IndentedJSON(http.StatusOK, gin.H{"team": team})
}

func (tc *TeamController) AddTeam(c *gin.Context) {

	ctx := c.Request.Context()

	var team domain.Team
	if err := c.ShouldBindJSON(&team); err != nil {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"error": "invalid input format"})
		return
	}

	err := tc.teamUsecase.AddTeam(ctx, &team)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.IndentedJSON(http.StatusOK, gin.H{"message": "team added successfully"})
}
func (tc *TeamController) AddTeamFromAPI(c *gin.Context) {

}

func (tc *TeamController) CacheTeams(c *gin.Context) {
	ctx := c.Request.Context()

	leagues := []int{363, 39} // ETH and EPL
	seasons := []int{2021, 2022, 2023}

	for _, leagueID := range leagues {
		for _, season := range seasons {
			err := tc.teamUsecase.FetchAndCacheTeams(ctx, leagueID, season)
			if err != nil {
				c.IndentedJSON(http.StatusInternalServerError, gin.H{
					"error": fmt.Sprintf("Failed to cache teams for league %d, season %d: %v", leagueID, season, err),
				})
				return
			}
		}
	}

	c.IndentedJSON(http.StatusOK, gin.H{
		"message": "Teams cached successfully for both leagues",
		"leagues": []int{363, 39},
		"seasons": seasons,
	})
}
