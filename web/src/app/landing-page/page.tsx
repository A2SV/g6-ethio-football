"use client";

import Link from "next/link";
import { Globe } from "lucide-react";
import { Button } from "@/src/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/src/components/ui/card";

export default function EthiopianFootballPage() {
  return (
    <div className="min-h-screen bg-white">
      <section
        id="hero"
        className="relative h-screen flex items-center justify-center overflow-hidden"
      >
        <div
          className="absolute inset-0 bg-cover bg-center bg-no-repeat z-0"
          style={{
            backgroundImage: `url('/image1.png')`,
          }}
        ></div>

        <div className="absolute inset-0 bg-black/40 z-10"></div>

        <header className="fixed top-0 left-0 w-full z-50 bg-green-900 px-8 py-4 flex items-center justify-between shadow-md">
          <div className="flex items-center space-x-20">
            {/* Logo */}
            <Link href="/" className="text-2xl  text-white">
              Logo
            </Link>

            {/* Navigation */}
            <nav className="flex space-x-6 text-white font-medium">
              <Link href="#hero" className="hover:text-amber-400 transition">
                Home Page
              </Link>
              <Link href="#about" className="hover:text-amber-400 transition">
                About Us
              </Link>
              <Link
                href="#services"
                className="hover:text-amber-400 transition"
              >
                Services
              </Link>
              <Link href="#feature" className="hover:text-amber-400 transition">
                Features
              </Link>
            </nav>
          </div>

          {/* Right Side: Language Switch */}
          <Button className="bg-white text-gray-900 px-4 py-2 rounded-full shadow-md hover:bg-gray-100 flex items-center gap-2">
            <Globe className="h-5 w-5" />
            ENG
          </Button>
        </header>

        <div className="absolute bottom-0 left-0 z-10 text-white p-8 md:p-12 max-w-2xl">
          <h1 className="text-4xl md:text-5xl font-bold mb-4 text-amber-400 leading-tight">
            Experience the Thrill <br /> of Ethiopian Football
          </h1>
          <p className="text-lg md:text-xl mb-6 text-gray-100">
            Join us in celebrating the passion and excitement of Ethiopian
            football. Stay updated with the latest news, match results, and
            player stories.
          </p>
          <div className="flex gap-4">
            <Button className="bg-white text-gray-900 px-6 py-3 font-semibold rounded-none">
              <Link href="/chat">Join</Link>
            </Button>
            <Button
              variant="outline"
              className="bg-inherit border-white text-white hover:bg-white hover:text-black px-6 py-3 rounded-none"
            >
              <Link href="#feature">Learn More</Link>
            </Button>
          </div>
        </div>
      </section>

      {/* Discover Section */}
      <section id="about" className="py-20 px-4 bg-gray-50">
        <div className="max-w-6xl mx-auto">
          <div className="grid lg:grid-cols-2 gap-12 items-center">
            <div>
              <img
                src="/image2.png"
                alt="Ethiopian football player in action"
                className="rounded-lg shadow-lg w-full h-auto"
              />
            </div>
            <div className="space-y-6 bg-[#E7F2EC] h-[22rem] p-8 rounded-lg transition transform duration-300 hover:scale-105 hover:shadow-xl">
              <h2 className="text-4xl font-bold text-gray-900">
                Discover the Heart of Ethiopian Football
              </h2>
              <p className="text-lg text-gray-600 leading-relaxed">
                Stay informed with the latest updates in Ethiopian football. Our
                platform brings you real-time news, match scores, and in-depth
                player profiles. Join a community that celebrates the passion
                and culture of the sport.
              </p>
            </div>
          </div>
        </div>
      </section>

      <section id="services" className="py-20 px-4 bg-white">
        <div className="max-w-6xl mx-auto">
          <Card className="overflow-hidden border border-gray-200 bg-[#E7F2EC] shadow-lg">
            <div className="grid lg:grid-cols-2 gap-0">
              <CardContent className="p-12 space-y-8">
                <h2 className="text-4xl font-bold mb-6 text-gray-900">
                  Discover the Ultimate Hub for Ethiopian Football Fans and
                  Enthusiasts
                </h2>

                <p className="text-lg text-gray-600 leading-relaxed">
                  EthioFootball keeps you informed with the latest news and
                  match updates. Join a vibrant community that shares your
                  passion for the beautiful game.
                </p>

                <ul className="space-y-4">
                  {[
                    "Lorem ipsum dolor sit amet.",
                    "Consectetur adipiscing elit.",
                    "Vestibulum ante ipsum primis.",
                  ].map((text, idx) => (
                    <li key={idx} className="flex items-start gap-3">
                      <div className="w-2 h-2 bg-gray-400 rounded-full mt-3"></div>
                      <p className="text-gray-600">{text}</p>
                    </li>
                  ))}
                </ul>
              </CardContent>

              <div className="relative">
                <img
                  src="/image6.png"
                  alt="Ethiopian football fans celebrating with ETHIOPIA scarf"
                  className="w-full h-full object-cover"
                />
              </div>
            </div>
          </Card>
        </div>
      </section>

      {/* Feature Cards */}
      <section id="feature" className="py-20 px-4 bg-[#E7F2EC]">
        <div className="max-w-6xl mx-auto">
          <div className="grid md:grid-cols-3 gap-8">
            {[
              {
                img: "/image3.png",
                title: "Stay Updated with Latest News",
                desc: "Get the freshest news on local leagues and national teams.",
              },
              {
                img: "/image4.png",
                title: "Real-Time Match Scores at Your Fingertips",
                desc: "Follow live scores and updates for every match.",
              },
              {
                img: "/image5.png",
                title: "Explore In-Depth Team Profiles",
                desc: "Learn about your favorite players and their journeys.",
              },
            ].map((card, idx) => (
              <Card
                key={idx}
                className="border border-gray-200 hover:shadow-lg transition-shadow duration-300 overflow-hidden bg-white"
              >
                <div className="h-48 overflow-hidden">
                  <img
                    src={card.img}
                    alt={card.title}
                    className="w-full h-full object-cover"
                  />
                </div>
                <CardHeader className="text-center pb-2">
                  <CardTitle className="text-xl text-gray-900">
                    {card.title}
                  </CardTitle>
                </CardHeader>
                <CardContent className="text-center">
                  <CardDescription className="text-base leading-relaxed text-gray-600 mb-4">
                    {card.desc}
                  </CardDescription>
                </CardContent>
              </Card>
            ))}
          </div>

          <div className="text-center mt-12">
            <Button className="bg-amber-500 hover:bg-amber-600 text-white px-8 py-3 rounded-none">
              <Link href="/chat">Learn More →</Link>
            </Button>
          </div>
        </div>
      </section>
    </div>
  );
}
