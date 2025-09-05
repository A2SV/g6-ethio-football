import LiveHubRoutings from '@/src/components/ui/LiveHubRoutings';
import MatchCard from '@/src/components/ui/todaysMatchCard';
import React from 'react';

const liveScores = () => {
  const matches = [
    { league: 'EPL', homeTeam: 'Arsenal', awayTeam: 'Chelsea', score: '2-1', isLive: true },
    { league: 'EPL', homeTeam: 'Liverpool', awayTeam: 'Man City', score: '1-1', isLive: false },
  ];

  return (
    <div className="m-5 flex flex-col items-center">
  <LiveHubRoutings />

  <div className="flex justify-between items-center mt-6 mb-4 w-full max-w-[700px] px-2">
    <h1 className="text-xl ">Today's Matches</h1>
    <div className="bg-red-500 text-white px-2 rounded text-center text-sm">Live</div>
  </div>

  <div className="flex flex-col gap-3 w-full max-w-[700px]">
    {matches.map((match, index) => (
      <MatchCard
        key={index}
        league={match.league}
        homeTeam={match.homeTeam}
        awayTeam={match.awayTeam}
        score={match.score}
        isLive={match.isLive}
      />
    ))}
  </div>
</div>
  )
};

export default liveScores;
