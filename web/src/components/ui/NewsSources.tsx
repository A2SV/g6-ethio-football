export default function NewsSources() {
	const sources = [
		"BBC Sport",
		"Sky Sports",
		"ESPN",
		"Capital Ethiopia",
		"Ethiopian Reporter",
		"Ethiopian Football Federation",
	];

	return (
		<div className="p-6 border bg-gray-50">
			<h2 className="font-semibold text-lg mb-3">News Sources</h2>
			<ul className="flex flex-wrap gap-4 text-sm text-gray-700">
				{sources.map((src) => (
					<li key={src} className="flex items-center gap-2">
						<span className="w-2 h-2 rounded-full bg-green-600" />
						{src}
					</li>
				))}
			</ul>
			<p className="text-xs text-gray-500 mt-3">
				News articles are automatically aggregated from RSS feeds and updated
				every 15 minutes.
			</p>
		</div>
	);
}
