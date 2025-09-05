import type { Metadata } from "next";
import "./global.css";
import Navbar from "../components/shared/NavBar";
import Footer from "../components/shared/Footer";

export const metadata: Metadata = {
  title: " EthioFootball App",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="font-newsreader flex flex-col min-h-screen">
        <Navbar />
        <main className="flex-1">{children}</main>
        <Footer></Footer>
      </body>
    </html>
  );
}
