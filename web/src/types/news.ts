export interface NewsItem {
  id: string;
  title: string;
  description: string;
  imageUrl?: string;
  status?: "Live" | "Updated" | "Curated";
  category?: string;
  publishedAt?: string;
  sourceName?: string;
  url?: string;
}

export interface NewsResponse {
  items: NewsItem[];
}


