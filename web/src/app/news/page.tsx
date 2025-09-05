import NewsGrid from "@/src/components/ui/NewsGrid";
import NewsSources from "@/src/components/ui/NewsSources";
import { fetchNews, extractCategories } from "@/src/lib/news";

export const revalidate = 900; // 15 minutes

export default async function NewsPage() {
	const { items } = await fetchNews({ leagues: "ETH|EPL" });
	const tabs = extractCategories(items);

	return (
		<main className="p-6 space-y-10 max-w-6xl mx-auto">
			<NewsGrid items={items} tabs={tabs} />
			<NewsSources />
		</main>
	);
}
