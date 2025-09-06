"use client";
import { useState } from "react";
import Image from "next/image";

import Sidebar from "@/src/components/Sidebar";
import ChatBox from "@/src/components/ChatBox";
import EthiopianFootballCard from "@/src/components/EthiopianFootballCard";

import { mockChatResponses } from "@/public/mock/chatResponse";

export default function MainContent() {
  const [message, setMessage] = useState("");
  const [chat, setChat] = useState<{ sender: "user" | "bot"; text: string }[]>(
    []
  );

  const handleSend = async (presetMessage?: string) => {
    const finalMessage = presetMessage || message;
    if (!finalMessage.trim()) return;

    const userMessage = { sender: "user" as const, text: finalMessage };
    setChat((prev) => [...prev, userMessage]);
    setMessage("");

    try {
      if (process.env.NEXT_PUBLIC_API_URL) {
        const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/intent/parser`, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ userPrompt: finalMessage }),
        });
        if (!res.ok) throw new Error(`Server responded with ${res.status}`);
        const data = await res.json();
        const botResponse = data.markdown || "No response from server.";
        setChat((prev) => [...prev, { sender: "bot", text: botResponse }]);
      } else {
        const botResponse =
          mockChatResponses[finalMessage] ||
          "I don't have a response for that yet.";

        setTimeout(() => {
          setChat((prev) => [...prev, { sender: "bot", text: botResponse }]);
        }, 500); 
      }
    } catch (error) {
      console.error(error);
      setChat((prev) => [
        ...prev,
        { sender: "bot", text: "Something went wrong. Please try again." },
      ]);
    }
  };

  return (
    <div className="flex flex-col lg:flex-row p-4 lg:p-8 gap-6 lg:gap-8 max-w-7xl w-full mx-auto h-[calc(70vh-70px)] mb-50">
      <div className="flex flex-col flex-1 gap-6">
        {chat.length === 0 ? (
          <EthiopianFootballCard handleSend={handleSend} />
        ) : (
          <ChatBox chat={chat} />
        )}

        <div className="p-4 bg-gray-50 rounded-2xl shadow-lg border border-gray-200">
          <div className="flex items-center gap-2">
            <input
              type="text"
              placeholder="Ask about teams, players, matches..."
              value={message}
              onChange={(e) => setMessage(e.target.value)}
              onKeyDown={(e) => e.key === "Enter" && handleSend()}
              className="flex-1 border-none focus:outline-none bg-transparent text-gray-800 placeholder-gray-400"
            />
            <button onClick={() => handleSend()}>
              <Image src="/Email Send.png" alt="send" width={24} height={24} />
            </button>
          </div>
        </div>
      </div>

      <div className="hidden lg:block lg:w-80">
        <Sidebar />
      </div>
    </div>
  );
}