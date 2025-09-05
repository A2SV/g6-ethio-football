import Image from "next/image";
import Link from "next/link";

export default function NotFoundPage() {
	return (
		<div className="flex flex-col items-center justify-center min-h-screen text-center px-4">
			{/* Illustration */}
			<Image
				src="/football-player.png" 
				alt="Football player illustration"
				width={250}
				height={250}
				className="mb-6"
			/>

			{/* Title */}
			<h1 className="text-2xl font-bold mb-2">Oops! Page Not Found</h1>

			{/* Description */}
			<p className="text-gray-600 max-w-md mb-6">
				It looks like the page you were looking for has taken a detour. Don’t
				worry, you can always find your way back to the action!
			</p>

			{/* Buttons */}
			<div className="flex flex-wrap justify-center gap-3">
				<Link
					href="/"
					className="px-6 py-2 rounded-lg font-medium bg-blue-900 text-white hover:bg-blue-800"
				>
					Home
				</Link>
				<Link
					href="/liveScores"
					className="px-6 py-2 rounded-lg font-medium border border-gray-300 hover:bg-gray-100"
				>
					Live Hub
				</Link>
				<Link
					href="/compare"
					className="px-6 py-2 rounded-lg font-medium border border-gray-300 hover:bg-gray-100"
				>
					Compare
				</Link>
				<Link
					href="/news"
					className="px-6 py-2 rounded-lg font-medium border border-gray-300 hover:bg-gray-100"
				>
					News
				</Link>
			</div>
		</div>
	);
}
