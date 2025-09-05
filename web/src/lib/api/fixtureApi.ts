import { createApi } from "@reduxjs/toolkit/query/react";
import { apiClient } from '../apiClient';

type Fixture = {
  id: string;
  home_team: string;
  away_team: string;
  league: string;
  kickoff: string;
  status: string;
};

type FixtureResponse = {
  fixtures: Fixture[];
  freshness: {
    source: string;
    retrieved: string;
  };
};

export const fixtureApi = createApi({
  reducerPath: "fixtureApi",
  baseQuery: apiClient,
  tagTypes: ["Fixtures"],
  endpoints: (builder) => ({
    getFixtures: builder.query<FixtureResponse, { league?: string; team?: string; from?: string; to?: string } | void>({
  query: (params) => {
    if (!process.env.NEXT_PUBLIC_API_URL) {
      return '/fixtures';
    }
    const searchParams = new URLSearchParams();
    if (params?.league) searchParams.append("league", params.league);
    if (params?.team) searchParams.append("team", params.team);
    if (params?.from) searchParams.append("from", params.from);
    if (params?.to) searchParams.append("to", params.to);

    return `/fixtures?${searchParams.toString()}`;
  },
})

  }),
});

export const { useGetFixturesQuery } = fixtureApi;