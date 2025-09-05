import React from "react";

interface ChatMessage {
  sender: "user" | "bot";
  text: string;
}

interface ChatBoxProps {
  chat: ChatMessage[];
}

const ChatBox: React.FC<ChatBoxProps> = ({ chat }) => {
  return (
    <div className="flex-1 p-6 shadow-xl border border-gray-200 rounded-2xl space-y-4 overflow-y-auto bg-white transition-all duration-300">
      <div className="space-y-4">
        {chat.map((msg, idx) => (
          <div
            key={idx}
            className={`flex ${
              msg.sender === "user" ? "justify-end" : "justify-start"
            }`}
          >
            <div
              className={`px-4 py-3 rounded-2xl max-w-sm sm:max-w-md break-words ${
                msg.sender === "user"
                  ? "bg-green-600 text-white shadow-md"
                  : "bg-gray-100 text-gray-800 shadow-sm"
              }`}
            >
              {msg.text}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default ChatBox;
