import LiveHubRoutings from '@/src/components/ui/LiveHubRoutings';
import React from 'react';
import MatchCard from '@/src/components/ui/upcomingMatchCard';

const Fixture = () => {
  const upcomingMatches = [
    { league: 'EPL', homeTeam: 'Arsenal', awayTeam: 'Chelsea', kickoff: '2025-09-01T16:30:00Z' },
    { league: 'EPL', homeTeam: 'Liverpool', awayTeam: 'Man City', kickoff: '2025-09-01T16:30:00Z' },
  ];

  return (
    <div className="m-5 flex flex-col items-center">
      <LiveHubRoutings currentPath="/fixtures" />

  <div className="flex justify-between items-center mt-6 mb-4 w-full max-w-[700px] px-2">
        <h1 className="text-xl">Upcoming Fixtures</h1>
      </div>

      <div className="flex flex-col gap-3 w-full max-w-[700px]">
        {upcomingMatches.map((match, index) => (
          <MatchCard
            key={index}
            league={match.league}
            homeTeam={match.homeTeam}
            awayTeam={match.awayTeam}
            kickoff={match.kickoff}
          />
        ))}
      </div>
    </div>
  );
};

export default Fixture;
