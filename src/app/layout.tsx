'use client'
import './global.css'
import { Provider } from 'react-redux'
import { store } from '../lib/redux/store'


export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode
}>) {
  return (
    <html lang="en">
      <body className="font-newsreader bg-gray-50 min-h-screen">
        <Provider store={store}>
          {children}
        </Provider>
      </body>
    </html>
  )
}
