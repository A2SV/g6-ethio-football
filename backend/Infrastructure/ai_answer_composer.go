package infrastructure

import (
	"context"
	"encoding/json"
	"fmt"

	domain "github.com/abrshodin/ethio-fb-backend/Domain"
	genai "github.com/google/generative-ai-go/genai"
	"google.golang.org/api/option"
)

type AIAnswerComposer struct {
	apiKey string
}

func NewAIAnswerComposer(apiKey string) *AIAnswerComposer {
	return &AIAnswerComposer{apiKey: apiKey}
}

func (c *AIAnswerComposer) ComposeAnswer(dCtx domain.AnswerContext) (*domain.Answer, error) {
	return c.composeMarkdown(dCtx)
}

// --- Private helper for generating Markdown ---
func (c *AIAnswerComposer) composeMarkdown(dCtx domain.AnswerContext) (*domain.Answer, error) {
	ctx := context.Background()
	client, err := genai.NewClient(ctx, option.WithAPIKey(c.apiKey))
	if err != nil {
		return nil, domain.ErrUnexpected
	}
	defer client.Close()

	model := client.GenerativeModel("gemini-1.5-flash-latest")
	contextBytes, _ := json.MarshalIndent(dCtx.ContextData, "", "  ")

	language := "English"
	if dCtx.Language == "am" {
		language = "Amharic"
	}

	prompt := fmt.Sprintf(`You are a helpful and concise football assistant for Ethiopian fans.
	Your task is to write a short, friendly summary in %s using ONLY the data provided below.

	**Rules:**
	- Use ONLY the provided data. Do not make up scores, fixtures, or facts.
	- If a piece of information is missing from the data, say "it is not available" or "is not confirmed."
	- The output MUST be markdown.
	- The tone should be friendly and respectful of all clubs.
	- NO betting or gambling language.
	- For Compare outline that this is a season 2022 stat comparisions

	**Provided Data (JSON format):**
	%s

	Now, write the summary:`, language, string(contextBytes))

	resp, err := model.GenerateContent(ctx, genai.Text(prompt))
	if err != nil {
		return nil, domain.ErrUnexpected
	}

	var markdownContent string
	if len(resp.Candidates) > 0 && resp.Candidates[0].Content != nil { // Simplified check
		part := resp.Candidates[0].Content.Parts[0]
		if txt, ok := part.(genai.Text); ok {
			markdownContent = string(txt)
		}
	}
	if markdownContent == "" {
		return nil, domain.ErrUnexpected
	}

	// Construct an Answer object with ONLY the Markdown field populated.
	answer := &domain.Answer{
		Markdown:  markdownContent,
		Source:    dCtx.Source,
		Freshness: dCtx.Freshness,
	}
	return answer, nil
}

