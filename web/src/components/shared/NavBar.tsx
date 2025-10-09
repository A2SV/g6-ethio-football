"use client";

import Link from "next/link";
import { Globe, User } from "lucide-react";
import { usePathname } from "next/navigation";

const navItems = [
  { name: "Home", href: "/landing-page" },
  { name: "Chat", href: "/chat" },
  { name: "Live Hub", href: "/liveScores" },
  { name: "Compare", href: "/compare" },
  { name: "News", href: "/news" },
  { name: "Offline", href: "/Offline" },
  // { name: "My Clubs", href: "/my-clubs" },
];

export default function Navbar() {
  const pathname = usePathname();

  return (
    <nav className="w-full bg-white shadow-sm px-6 py-3 flex items-center justify-between">
      <div className="text-2xl font-bold italic">Logo</div>

      <div className="flex space-x-6">
        {navItems.map((item) => (
          <Link
            key={item.name}
            href={item.href}
            className={`text-sm hover:text-green-700 ${
              pathname === item.href
                ? "font-medium text-green-900 border-b-2 border-green-900 pb-1"
                : "text-gray-700"
            }`}
          >
            {item.name}
          </Link>
        ))}
      </div>

      <div className="flex items-center space-x-4">
        <User className="w-5 h-5 text-gray-700 cursor-pointer" />
        <button className="flex items-center border px-3 py-1 rounded-lg shadow-sm hover:bg-gray-50 text-sm">
          <Globe className="w-4 h-4 mr-2" />
          ENG
        </button>
      </div>
    </nav>
  );
}
