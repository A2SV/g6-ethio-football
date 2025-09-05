import "server-only";

import { NewsItem, NewsResponse } from "@/src/types/news";

const DEFAULT_NEWS: NewsItem[] = [
  {
    id: "1",
    imageUrl: "/news1.jpg",
    status: "Live",
    category: "Premier League",
    title: "Arsenal Extends Lead at Top of Premier League",
    publishedAt: "2024-01-01T10:00:00Z",
    sourceName: "BBC Sport",
    description:
      "Bukayo Saka’s brilliant double helped Arsenal secure a crucial 3-1 victory over Chelsea at Emirates Stadium. The Gunners now sit 5 points clear at the top.",
    url: "https://www.bbc.co.uk/sport",
  },
  {
    id: "2",
    imageUrl: "/news2.jpg",
    status: "Updated",
    category: "Ethiopian Football",
    title: "Ethiopia Secures Win in CAF Qualifiers",
    publishedAt: "2024-01-01T08:00:00Z",
    sourceName: "Capital Ethiopia",
    description:
      "The Ethiopian national team secured a thrilling 2-1 win in the CAF qualifiers, keeping their hopes alive for the tournament.",
    url: "https://www.capitalethiopia.com/",
  },
  {
    id: "3",
    imageUrl: "/news3.jpg",
    status: "Curated",
    category: "International",
    title: "UEFA Champions League Heats Up",
    publishedAt: "2023-12-31T10:00:00Z",
    sourceName: "Sky Sports",
    description:
      "The knockout stages of the Champions League continue to deliver surprises as underdogs rise against Europe’s football giants.",
    url: "https://www.skysports.com/",
  },
];

export type FetchNewsOptions = {
  signal?: AbortSignal;
  leagues?: string;
  baseUrl?: string;
};

function mapApiItemToNewsItem(api: any): NewsItem {
  return {
    id: String(api.id),
    title: api.title ?? "",
    description: api.snippet ?? api.content ?? "",
    imageUrl: api.image_url ?? undefined,
    status: undefined,
    category: undefined,
    publishedAt: api.published_at ?? undefined,
    sourceName: api.source ?? undefined,
    url: api.url ?? undefined,
  };
}

export async function fetchNews(opts: FetchNewsOptions = {}): Promise<NewsResponse> {
  const { signal, leagues = "ETH|EPL", baseUrl } = opts;
  const endpoint = `${baseUrl ?? process.env.NEXT_PUBLIC_API_BASE ?? ""}/news?league=${encodeURIComponent(leagues)}`;

  try {
    if (!endpoint || endpoint.endsWith("/news?league=")) {
      return { items: DEFAULT_NEWS };
    }

    const res = await fetch(endpoint, {
      method: "GET",
      signal,
      next: { revalidate: 900 },
      headers: {
        "Content-Type": "application/json",
      },
    });

    if (!res.ok) {
      throw new Error(`Failed to fetch news: ${res.status}`);
    }

    const raw = await res.json();
    const array = Array.isArray(raw) ? raw : Array.isArray(raw?.items) ? raw.items : [raw];
    const items = array.map(mapApiItemToNewsItem);
    return { items };
  } catch (_error) {
    return { items: DEFAULT_NEWS };
  }
}

export function extractCategories(items: NewsItem[]): string[] {
  const set = new Set<string>(["All News"]);
  for (const item of items) {
    if (item.category) set.add(item.category);
  }
  return Array.from(set);
}


