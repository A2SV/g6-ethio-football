import { Calendar } from "lucide-react";
import { NewsItem } from "@/src/types/news";

interface NewsCardProps {
	item: NewsItem;
}

export default function NewsCard({ item }: NewsCardProps) {
    const { imageUrl, status, category, title, publishedAt, sourceName, description, url } = item;
	return (
		<div className="overflow-hidden shadow-md border bg-white flex flex-col rounded-md">
			{/* Image + Tags */}
			<div className="relative">
				<img src={imageUrl ?? "/news-placeholder.jpg"} alt={title} className="w-full h-48 object-cover" />
				{status ? (
					<span className="absolute top-2 left-2 bg-red-500 text-white text-xs px-3 py-1 rounded-md">
						{status}
					</span>
				) : null}
				{category ? (
					<span className="absolute top-2 right-2 bg-gray-800 text-white text-xs px-3 py-1 rounded-md">
						{category}
					</span>
				) : null}
			</div>

			{/* Content */}
			<div className="p-4 flex flex-col flex-grow">
				<h3 className="text-lg font-semibold">{title}</h3>
				<p className="text-sm text-gray-500 flex items-center mt-1">
					<Calendar className="w-4 h-4 mr-1" />
					{publishedAt ? new Date(publishedAt).toLocaleString() : ""}
					{sourceName ? (publishedAt ? ` · ${sourceName}` : sourceName) : ""}
				</p>
				<p className="text-sm text-gray-600 mt-2 flex-grow">{description}</p>

				{/* Buttons */}
				<div className="mt-4 flex gap-2">
					{url ? (
						<a href={url} target="_blank" rel="noopener noreferrer" className="px-4 py-2 border rounded-lg text-sm hover:bg-gray-100">
							Read Source
						</a>
					) : null}
					<button className="px-4 py-2 bg-green-600 text-white rounded-lg text-sm hover:bg-green-700">
						RSS Feed
					</button>
				</div>
			</div>
		</div>
	);
}
