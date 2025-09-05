"use client";

export default function ErrorNews({
  error,
}: {
  error: Error & { digest?: string };
}) {
  return (
    <main className="p-6 space-y-4">
      <h2 className="text-red-600 font-semibold text-lg">
        Failed to load news
      </h2>
      <p className="text-sm text-gray-600">Please try again later.</p>
      {process.env.NODE_ENV !== "production" ? (
        <pre className="text-xs bg-red-50 border border-red-200 p-2 rounded overflow-auto">
          {error?.message}
        </pre>
      ) : null}
    </main>
  );
}
