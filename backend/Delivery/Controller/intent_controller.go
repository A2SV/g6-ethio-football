package controller

import (
	"errors"
	"fmt"
	"log"
	"net/http"
	"strconv"
	"time"

	domain "github.com/abrshodin/ethio-fb-backend/Domain"
	"github.com/abrshodin/ethio-fb-backend/Usecase"
	"github.com/gin-gonic/gin"
)

type IntentController struct {
	parseIntent *usecase.ParseIntentUseCase
	standingUC	*StandingsController
	newsUC      *NewsController
	teamUC 		*TeamController
	answerC     *AnswerController
	fixtureUC   usecase.IFixturesUsecase
}

func NewIntentController(
	parseIntent *usecase.ParseIntentUseCase, 
	st *StandingsController, 
	ns *NewsController, 
	tc *TeamController, 
	answerHander *AnswerController,
	fixtureUC   usecase.IFixturesUsecase,
	) *IntentController {

	return &IntentController{
		parseIntent: parseIntent,
		standingUC: st,
		newsUC: ns,
		teamUC: tc,
		answerC: answerHander,
		fixtureUC: fixtureUC,
	}
}

func (h *IntentController) ParseIntent(c *gin.Context) {
	ctx := c.Request.Context()

	var req struct {
		Text string `json:"text"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid request body"})
		return
	}

	intent, err := h.parseIntent.Execute(req.Text)
	if err != nil {
		switch {
		case errors.Is(err, usecase.ErrInvalidInput):
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		default:
			log.Print(err)
			c.JSON(http.StatusInternalServerError, gin.H{"error": "internal server error"})
		}
		return
	}

	fmt.Println("intent : ", intent)

	var data any
	season := 2022
	leagueID := 0

	switch intent.League {
	case "ETH":
		leagueID = 363
	case "EPL":
		leagueID = 39
	}

	switch intent.Topic {
	case "fixture":
			query := domain.RoundQuery{
				League: intent.League,
				Season: 2022,
				Round: "1",
			}
			
			fmt.Println("query :", query)
			response := make([]any, 0)
			answer, err := h.fixtureUC.GetCachedByRound(ctx, query)
			if err != nil {
				break
			}
			response = append(response, answer)
			data = response

		fmt.Println("data :", data)

	case "table":
		data, err = h.standingUC.standingsUsecase.GetStandings(ctx, leagueID, season)
		fmt.Println("data :", data)
		if err != nil {
			fmt.Println("err :", err)
			c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": "Error while fetching standings"})
			return
		}

	case "news":
		var answer []any
		if ans, err := h.newsUC.newsUC.GenerateStandingNews(); err == nil {
			answer = append(answer, ans)
		}
		if ans, err := h.newsUC.newsUC.GenerateFutureNews(); err == nil {
			answer = append(answer, ans)
		}
		if ans, err := h.newsUC.newsUC.GenerateLiveScores(); err == nil {
			answer = append(answer, ans)
		}
		if ans, err := h.newsUC.newsUC.GenerateNews(); err == nil {
			answer = append(answer, ans)
		}
		data = answer

	case "compare":
		if len(intent.Teams) < 2 {
			c.JSON(http.StatusBadRequest, gin.H{"error": "two teams are required for comparison"})
			return
		}

		teamA := intent.Teams[0]
		teamB := intent.Teams[1]

		team1Data, err := h.teamUC.teamUsecase.Statistics(ctx, leagueID, season, teamA)
		if err != nil {
			fmt.Println("error", err)
			c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": "Error while fetching data for team A"})
			return
		}

		team2Data, err := h.teamUC.teamUsecase.Statistics(ctx, leagueID, season, teamB)
		if err != nil {
			c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": "Error while fetching data for team B"})
			return
		}

		data = domain.ComparisonData{
			TeamA: team1Data,
			TeamB: team2Data,
		}
	case "fact":
		data = intent.Teams
			
	default:
		c.JSON(http.StatusBadRequest, gin.H{"error": "unsupported topic"})
		return
	}

	cData := map[string]interface{}{"data": data}
	answerContext := domain.AnswerContext{
		Topic:       intent.Topic,
		Language:    intent.Language,
		Source:      "api",
		Freshness:   time.Now(),
		ContextData: cData,
	}

	// Call answer usecase
	answer, err := h.answerC.answerUsecase.Compose(ctx, answerContext)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to compose answer"})
		return
	}

	c.JSON(http.StatusOK, answer)
}

func (h *IntentController) HandleCompare(c *gin.Context){

	teamA := c.Query("teamA")
	teamB := c.Query("teamB")
	league := c.Query("league")

	if teamA == "" || teamB == "" || league == "" {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"error" : "two teams are needed"})
		return 
	}

	team_a, _ := strconv.Atoi(teamA)
	team_b, _ := strconv.Atoi(teamB) 

	leagueID := 0
	if league == "ETH" {
		leagueID = 363
	} else if league == "EPL" {
		leagueID = 39
	} else {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"error": "unsupported league"})
		return 
	}

	season := 2022
	team1Data, err := h.teamUC.teamUsecase.StatisticsByID(c, leagueID, season, team_a)
		if err != nil {
			fmt.Println("error", err)
			c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": "Error while fetching data for team A"})
			return
		}

	team2Data, err := h.teamUC.teamUsecase.StatisticsByID(c, leagueID, season, team_b)
	if err != nil {
		fmt.Print("err : ", err)
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": "Error while fetching data for team B"})
		return
	}

	data := domain.ComparisonData{
		TeamA: team1Data,
		TeamB: team2Data,
	}

	c.IndentedJSON(http.StatusOK, gin.H{"comparison_data": data})
}

