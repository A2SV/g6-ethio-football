"use client";
import Link from "next/link";
import React, { useState } from "react";
import Image from "next/image";

interface LiveHubRoutingsProps {
  currentPath: string;
}

const LiveHubRoutings: React.FC<LiveHubRoutingsProps> = ({ currentPath }) => {
  const links = [
    { href: "/liveScores", label: "Live Scores", icon: "icons/access_time.svg" },
    { href: "/fixtures", label: "Fixtures", icon: "icons/calendar_today.svg" },
    { href: "/table", label: "Table", icon: "icons/table.svg" },
  ];

  const [hovered, setHovered] = useState<string | null>(null);

  return (
    <div className="flex flex-col sm:flex-row flex-wrap justify-center sm:justify-around sm:gap-x-2 gap-y-2 bg-gray-100 py-2 px-5 rounded w-full max-w-[95%] sm:max-w-[700px] mx-auto">
      {links.map((link) => {
        const isActive = currentPath === link.href;
        const isHighlighted = hovered === link.href || (!hovered && isActive);

        return (
          <Link
            key={link.href}
            href={link.href}
            onMouseEnter={() => setHovered(link.href)}
            onMouseLeave={() => setHovered(null)}
            className={`relative flex items-center justify-center gap-2
              w-full sm:w-[200px] h-[40px] rounded text-center
              transition-colors duration-300
              ${isHighlighted ? "bg-white text-black" : "text-gray-700"}
            `}
          >
            <Image src={link.icon} alt={link.label} width={20} height={20} />
            {link.label}
          </Link>
        );
      })}
    </div>
  );
};

export default LiveHubRoutings;
