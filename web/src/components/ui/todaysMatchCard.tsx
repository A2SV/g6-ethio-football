import React from 'react';

const MatchCard = ({ league, homeTeam, awayTeam, score, isLive }: any) => {
  return (
    <div className="border border-gray-300 shadow-md rounded-md py-4 px-10 my-2 w-full bg-white transition-shadow  hover:shadow-2xl">
      <div className="text-sm text-gray-500 mb-2">{league}</div>

      <div className="flex justify-between items-center mb-2">
        <p className="font-medium">{homeTeam}</p>
        <p className="font-bold">{score}</p>
        <p className="font-medium">{awayTeam}</p>
      </div>

      {isLive ? (
        <div className="bg-red-600 text-white text-xs px-2 py-1 rounded inline-block">
          Live
        </div>
      ):
      <div className="bg-green-700 text-white text-xs px-2 py-1 rounded inline-block">
          FT
        </div> }
    </div>
  );
};

export default MatchCard;
