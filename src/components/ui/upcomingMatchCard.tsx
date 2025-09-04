'use client';
import React, { useState } from "react";

interface UpcomingMatchCardProps {
  league: string;
  homeTeam: string;
  awayTeam: string;
  kickoff: string | Date;
  homeLogo?: string;
  awayLogo?: string;
}

const UpcomingMatchCardResponsive: React.FC<UpcomingMatchCardProps> = ({
  league,
  homeTeam,
  awayTeam,
  kickoff,
  homeLogo,
  awayLogo,
}) => {
  const date = new Date(kickoff);
  const schedule = isNaN(date.getTime())
    ? "TBD"
    : new Intl.DateTimeFormat(undefined, {
        weekday: "short",
        month: "short",
        day: "numeric",
        hour: "2-digit",
        minute: "2-digit",
      }).format(date);

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
        <span className="text-s font-medium text-gray-600 px-3 py-1 rounded-full">
          {league}
        </span>
        <time className="text-s text-gray-600 wrap">
          {schedule}
        </time>
      </div>

      <div className="flex items-center justify-between relative z-10">
        <div className="flex flex-col items-center w-5/12">
          {homeLogo ? (
            <img src={homeLogo} alt={homeTeam} className="h-12 w-12 object-contain mb-2" />
          ) : (
            <div className="h-12 w-12 rounded-full bg-gray-100 flex items-center justify-center mb-2">
              <span className="text-xs font-bold text-gray-500">HOME</span>
            </div>
          )}
          <span className="font-semibold text-base text-gray-800 text-center truncate w-full">
            {homeTeam}
          </span>
        </div>

        <div className="flex flex-col items-center w-2/12">
          <div className="font-bold text-white px-3 py-1.5 rounded bg-gradient-to-r from-green-500 to-green-600 shadow-sm text-xs">
            VS
          </div>
        </div>

        <div className="flex flex-col items-center w-5/12">
          {awayLogo ? (
            <img src={awayLogo} alt={awayTeam} className="h-12 w-12 object-contain mb-2" />
          ) : (
            <div className="h-12 w-12 rounded-full bg-gray-100 flex items-center justify-center mb-2">
              <span className="text-xs font-bold text-gray-500">AWAY</span>
            </div>
          )}
          <span className="font-semibold text-base text-gray-800 text-center truncate w-full">
            {awayTeam}
          </span>
        </div>
      </div>
    </div>
  );
};

export default UpcomingMatchCardResponsive;