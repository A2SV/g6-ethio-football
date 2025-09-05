import React from "react";

// Define interface for props
interface EthiopianFootballCardProps {
  handleSend: (message: string) => void;
}

const EthiopianFootballCard: React.FC<EthiopianFootballCardProps> = ({
  handleSend,
}) => {
  return (
    <div className="flex-1 flex flex-col items-center justify-center p-8 bg-white rounded-2xl shadow-lg border border-gray-200 text-center transition-all duration-300">
      <div className="mb-8">
        <h2 className="text-2xl sm:text-3xl font-bold mb-2 text-gray-900">
          Ask anything about Ethiopian football
        </h2>
        <p className="text-gray-600 text-sm sm:text-base">
          Get live scores, team stats, player info, and match analysis.
        </p>
      </div>

      <div className="flex flex-wrap justify-center gap-4">
        <button
          onClick={() => handleSend("EPL Table")}
          className="px-6 py-2 border border-gray-300 rounded-full hover:bg-gray-100 transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2"
        >
          EPL Table
        </button>
        <button
          onClick={() => handleSend("Walias Next Match")}
          className="px-6 py-2 border border-gray-300 rounded-full hover:bg-gray-100 transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2"
        >
          Walias Next Match
        </button>
        <button
          onClick={() => handleSend("Local Clubs")}
          className="px-6 py-2 border border-gray-300 rounded-full hover:bg-gray-100 transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2"
        >
          Local Clubs
        </button>
      </div>
    </div>
  );
};

export default EthiopianFootballCard;
