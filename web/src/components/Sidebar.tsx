export default function Sidebar() {
  return (
    <aside className="p-4 rounded-2xl bg-[#E7F2EC] shadow-md  sm:w-72 lg:p-8 flex flex-col space-y-6">
      <h3 className="font-semibold text-lg text-gray-900">Explore</h3>
      <ul className="flex flex-col space-y-4 text-gray-700">
        <li>
          <a
            href="/liveScores"
            className="flex items-center gap-2 px-3 py-2 rounded-lg hover:text-green-600 hover:bg-green-100 transition-colors duration-200"
          >
            <span className="text-xl"></span> Live Scores
          </a>
        </li>
        <li>
          <a
            href="/compare"
            className="flex items-center gap-2 px-3 py-2 rounded-lg hover:text-green-600 hover:bg-green-100 transition-colors duration-200"
          >
            <span className="text-xl"></span> Team Compare
          </a>
        </li>
        <li>
          <a
            href="/news"
            className="flex items-center gap-2 px-3 py-2 rounded-lg hover:text-green-600 hover:bg-green-100 transition-colors duration-200"
          >
            <span className="text-xl"></span> Latest Views
          </a>
        </li>
        <li>
          <a
            href="/Offline"
            className="flex items-center gap-2 px-3 py-2 rounded-lg hover:text-green-600 hover:bg-green-100 transition-colors duration-200"
          >
            <span className="text-xl"></span> Offline Library
          </a>
        </li>
      </ul>
    </aside>
  );
}
