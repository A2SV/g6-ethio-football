import type { Metadata } from 'next'
import './global.css'

export const metadata: Metadata = {
  title: ' EthioFootball App',
}

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode
}>) {
  return (
    <html lang="en">
      <body
      className='font-newsreader'
      >{children}</body>
    </html>
  )
}
