import { createApi } from "@reduxjs/toolkit/query/react";
import { apiClient } from '../apiClient';

type Score = {
  id: string;
  home_team: string;
  away_team: string;
  home_team_score: string;
  away_team_score: string;
  home_team_logo?: string;
  away_team_logo?: string;
  league: string;
  status: string;
};

type LiveScoreResponse = {
  score: Score[];
  freshness: {
    source: string;
    retrieved: string;
  };
};

export const livescoreApi = createApi({
  reducerPath: "livescoreApi",
  baseQuery: apiClient,
  tagTypes: ["LiveScore"],
  endpoints: (builder) => ({
    getLiveScore: builder.query<LiveScoreResponse, { league?: string; team?: string; from?: string; to?: string } | void>({
  query: (params) => {
    if (!process.env.NEXT_PUBLIC_API_URL) {
      return '/livescore';
    }
   

    return `/livescore`;
  },
})

  }),
});

export const { useGetLiveScoreQuery } = livescoreApi;