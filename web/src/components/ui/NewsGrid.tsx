"use client";
import { useMemo, useState } from "react";
import NewsCard from "./NewsCard";
import NewsTabs from "./NewsTabs";
import { NewsItem } from "@/src/types/news";

interface NewsGridProps {
	items: NewsItem[];
	tabs: string[];
}

export default function NewsGrid({ items, tabs }: NewsGridProps) {
	const [activeTab, setActiveTab] = useState("All News");

	const filteredItems = useMemo(() => {
		if (activeTab === "All News") return items;
		return items.filter((item) => item.category === activeTab);
	}, [activeTab, items]);

	return (
		<div className="space-y-6">
			<NewsTabs tabs={tabs} activeTab={activeTab} setActiveTab={setActiveTab} />

			<div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
				{filteredItems.length > 0 ? (
					filteredItems.map((item) => <NewsCard key={item.id} item={item} />)
				) : (
					<p className="col-span-full text-center text-gray-500">
						No news available for this category.
					</p>
				)}
			</div>
		</div>
	);
}
