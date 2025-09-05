import { Facebook, Instagram, Twitter, Linkedin, Youtube } from "lucide-react";
import Link from "next/link";

export default function Footer() {
  return (
    <footer className="bg-[#224F38] text-white px-6 py-10">
      <div className="max-w-7xl mx-auto grid grid-cols-1 md:grid-cols-2 gap-8">
        <div>
          <h3 className="font-semibold mb-4">Quick Links</h3>
          <div className="flex flex-wrap gap-6 text-sm">
            <Link href="/news" className="hover:underline">
              Latest News
            </Link>
            <Link href="/matches" className="hover:underline">
              Match Results
            </Link>
            <Link href="/players" className="hover:underline">
              Player Profiles
            </Link>
            <Link href="/clubs" className="hover:underline">
              Club Highlights
            </Link>
            <Link href="/community" className="hover:underline">
              Fan Community
            </Link>
          </div>
        </div>

        {/* Logo */}
        <div className="flex justify-end items-start">
          <div className="text-2xl italic font-bold">Logo</div>
        </div>
      </div>

      <hr className="border-gray-500 my-6" />

      {/* Bottom Section */}
      <div className="max-w-7xl mx-auto flex flex-col md:flex-row items-center justify-between text-sm">
        <p className="text-gray-300">
          © 2025 EthioFootball. All rights reserved.{" "}
          <Link href="/privacy" className="hover:underline">
            Privacy Policy
          </Link>{" "}
          <Link href="/terms" className="hover:underline">
            Terms of Service
          </Link>{" "}
          <Link href="/cookies" className="hover:underline">
            Cookie Settings
          </Link>
        </p>

        {/* Social Icons */}
        <div className="flex space-x-4 mt-4 md:mt-0">
          <Link href="#">
            <Facebook className="w-5 h-5 hover:text-gray-300" />
          </Link>
          <Link href="#">
            <Instagram className="w-5 h-5 hover:text-gray-300" />
          </Link>
          <Link href="#">
            <Twitter className="w-5 h-5 hover:text-gray-300" />
          </Link>
          <Link href="#">
            <Linkedin className="w-5 h-5 hover:text-gray-300" />
          </Link>
          <Link href="#">
            <Youtube className="w-5 h-5 hover:text-gray-300" />
          </Link>
        </div>
      </div>
    </footer>
  );
}
