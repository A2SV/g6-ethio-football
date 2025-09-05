"use client";

interface NewsTabsProps {
	activeTab: string;
	setActiveTab: (tab: string) => void;
	tabs: string[];
}

export default function NewsTabs({ activeTab, setActiveTab, tabs }: NewsTabsProps) {
	return (
		<div className="flex w-fit m-auto my-8 justify-center gap-2 bg-[#E7F2EC] overflow-x-auto rounded-md px-4 py-2">
			{tabs.map((tab) => (
				<button
					key={tab}
					onClick={() => setActiveTab(tab)}
					className={`px-4 py-2 text-sm font-medium rounded-md whitespace-nowrap transition ${
						activeTab === tab
							? "bg-green-600 text-white"
							: "bg-white text-gray-800 hover:bg-gray-100"
					}`}
				>
					{tab}
				</button>
			))}
		</div>
	);
}
