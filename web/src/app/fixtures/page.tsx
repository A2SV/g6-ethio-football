'use client'
import LiveHubRoutings from '@/src/components/ui/LiveHubRoutings';
import React from 'react';
import MatchCard from '@/src/components/ui/upcomingMatchCard';
import { useGetFixturesQuery } from '../../lib/api/fixtureApi'; 

const Fixture = () => {
  const { data: upcomingMatches, error, isLoading } = useGetFixturesQuery();

  if (isLoading) return <p className="text-center mt-6">Loading fixtures...</p>;
  if (error) return <p className="text-center mt-6 text-red-500">Failed to load fixtures</p>;

  return (
    <div className="m-5 flex flex-col items-center">
      <LiveHubRoutings currentPath="/fixtures" />

      <div className="flex justify-between items-center mt-6 mb-4 w-full max-w-[700px] px-2">
        <h1 className="text-xl font-semibold">Upcoming Fixtures</h1>
      </div>

      <div className="flex flex-col gap-3 w-full max-w-[700px]">
        {upcomingMatches?.fixtures.map((match: any, index: number) => (
          <MatchCard
            key={index}
            league={match.league}
            homeTeam={match.home_team}
            awayTeam={match.away_team}
            kickoff={match.kickoff}
          />
        ))}
      </div>
    </div>
  );
};

export default Fixture;
