'use client'
import "./global.css";
import Navbar from "../components/shared/NavBar";
import Footer from "../components/shared/Footer";
import { Provider } from "react-redux";
import { store } from "../lib/redux/store"; 


export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="font-newsreader flex flex-col min-h-screen">
        <Provider store={store}>
          <Navbar />
          <main className="flex-1">{children}</main>
          <Footer />
        </Provider>
      </body>
    </html>
  );
}
