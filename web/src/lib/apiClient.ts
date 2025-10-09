import { fetchBaseQuery } from "@reduxjs/toolkit/query/react";
import type { BaseQueryFn, FetchArgs, FetchBaseQueryError } from "@reduxjs/toolkit/query";

const backendBaseQuery = fetchBaseQuery({
  baseUrl: process.env.NEXT_PUBLIC_API_URL,
});

export const apiClient: BaseQueryFn<string | FetchArgs, unknown, FetchBaseQueryError> = async (
  args,
  api,
  extraOptions
) => {
  if (process.env.NEXT_PUBLIC_API_URL) {
    return backendBaseQuery(args, api, extraOptions);
  }

  let url = typeof args === "string" ? args : args.url;
  return fetch(`/mock${url}.json`)
    .then((res) => res.json())
    .then((data) => ({ data }))
    .catch((error) => ({ error }));
};
