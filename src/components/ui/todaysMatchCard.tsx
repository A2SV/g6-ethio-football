'use client';
import React, { useState } from 'react';

interface MatchCardProps {
  league: string;
  homeTeam: string;
  awayTeam: string;
  score: string;
  isLive: boolean;
}

const MatchCard: React.FC<MatchCardProps> = ({
  league,
  homeTeam,
  awayTeam,
  score,
  isLive
}) => {
  const [isHovered, setIsHovered] = useState(false);
  const [isPressed, setIsPressed] = useState(false);

  return (
    <div
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => {
        setIsHovered(false);
        setIsPressed(false);
      }}
      onMouseDown={() => setIsPressed(true)}
      onMouseUp={() => setIsPressed(false)}
      onTouchStart={() => setIsPressed(true)}
      onTouchEnd={() => setIsPressed(false)}
      className="relative border border-gray-200 rounded-xl py-4 px-6 my-3 w-full transition-all duration-300 overflow-hidden"
      style={{
        backgroundColor: "#FFFFFF",
        boxShadow: isHovered 
          ? "0 4px 20px -5px rgba(208, 230, 215, 0.7), 0 4px 8px -4px rgba(0,0,0,0.05)" 
          : "0 3px 10px rgba(0,0,0,0.05)",
        transform: isHovered 
          ? (isPressed ? "scale(0.98)" : "scale(1.02)") 
          : "scale(1)",
        cursor: "pointer",
      }}
    >
      <div className="flex justify-between items-center mb-4 relative z-10">
        <span className="text-xs font-medium text-gray-600 bg-gray-100 px-3 py-1 rounded-full">
          {league}
        </span>
        <span className={`text-xs font-medium px-3 py-1 rounded-full ${isLive ? 'bg-red-500 text-white' : 'bg-gray-600 text-white'}`}>
          {isLive ? "LIVE" : "FT"}
        </span>
      </div>

      <div className="flex items-center justify-between relative z-10">
        <div className="flex flex-col items-center w-5/12">
          <div className="h-12 w-12 rounded-full bg-gray-100 flex items-center justify-center mb-2">
            <span className="text-xs font-bold text-gray-500">HOME</span>
          </div>
          <span className="font-semibold text-base text-gray-800 text-center truncate w-full">
            {homeTeam}
          </span>
        </div>

        {/* Score display */}
        <div className="flex flex-col items-center w-2/12">
          <span className="font-bold text-gray-800 text-xl mb-1">
            {score}
          </span>
          <div className="w-full h-px bg-gray-200"></div>
        </div>

        <div className="flex flex-col items-center w-5/12">
          <div className="h-12 w-12 rounded-full bg-gray-100 flex items-center justify-center mb-2">
            <span className="text-xs font-bold text-gray-500">AWAY</span>
          </div>
          <span className="font-semibold text-base text-gray-800 text-center truncate w-full">
            {awayTeam}
          </span>
        </div>
      </div>
    </div>
  );
};

export default MatchCard;