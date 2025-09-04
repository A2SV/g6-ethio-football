# EthioFootball Mobile (Flutter)

**EthioFootball** is an AI-powered football companion for Ethiopian fans.  
This repository contains the **Flutter mobile app**, built **mobile-first** with **offline support**, **Amharic/English localization**, and **lightweight football data integration**.  

---

## 📱 App Features

- **Chat Q&A** – Ask football questions in Amharic or English, get concise answers with freshness tags.  
- **Live Hub** – EPL (guaranteed) scores, fixtures, tables. Other leagues if available via API.  
- **Compare** – Team vs Team facts, rivalries, honors, recent form.  
- **News** – Summarized RSS sports feeds with “read source” links.  
- **My Clubs** – Follow up to 5 clubs (local/EPL), quick access + notifications.  
- **Offline Mode** – Cached club bios, FAQs, legends, and last known standings/fixtures.  

---

## 🛠️ Tech Stack

- **Framework:** Flutter (Dart)  
- **Key Packages:**  
  - `dio` – networking  
  - `sqflite` or `hive` – local storage/cache  
  - `cached_network_image` – optimized images  
  - `connectivity_plus` – online/offline detection  
  - `flutter_local_notifications` – fixture alerts  

---

## 📂 Project Structure

## 📂 Project Structure

lib/
├── main.dart                 # App entry point
├── features/
│   ├── Chat/                 # Chat feature (AI Q&A)
│   │   ├── Data/             # Data layer
│   │   │   ├── DataSources/  # API or local data sources
│   │   │   ├── Repositories/ # Implementations of repository interfaces
│   │   │   └── Models/       # Data models (DTOs)
│   │   ├── Domain/           # Domain layer (business logic)
│   │   │   ├── Entities/     # Core entities
│   │   │   ├── Usecases/     # Business logic / actions
│   │   │   └── Repositories/ # Repository interfaces
│   │   └── Presentation/     # UI screens, widgets, blocs/providers (if applicable)
│   │   │   ├── Widgets/     # Essential widgets
│   │   │   ├── Pages/     # Pages to display
│   │   │   └── Bloc/ # State Control
│   ├── LiveHub/              # Live scores, tables, fixtures
│   │   │   ├── Data/             # Data layer
│   │   │   ├── DataSources/  # API or local data sources
│   │   │   ├── Repositories/ # Implementations of repository interfaces
│   │   │   └── Models/       # Data models (DTOs)
│   │   ├── Domain/           # Domain layer (business logic)
│   │   │   ├── Entities/     # Core entities
│   │   │   ├── Usecases/     # Business logic / actions
│   │   │   └── Repositories/ # Repository interfaces
│   │   └── Presentation/     # UI screens, widgets, blocs/
│   │   │   ├── Widgets/     # Essential widgets
│   │   │   ├── Pages/     # Pages to display
│   │   │   └── Bloc/ # State Control
│   ├── Compare/              # Team comparison screens and logic
│   │   │   ├── Data/             # Data layer
│   │   │   ├── DataSources/  # API or local data sources
│   │   │   ├── Repositories/ # Implementations of repository interfaces
│   │   │   └── Models/       # Data models (DTOs)
│   │   ├── Domain/           # Domain layer (business logic)
│   │   │   ├── Entities/     # Core entities
│   │   │   ├── Usecases/     # Business logic / actions
│   │   │   └── Repositories/ # Repository interfaces
│   │   └── Presentation/     # UI screens, widgets, blocs/
│   │   │   ├── Widgets/     # Essential widgets
│   │   │   ├── Pages/     # Pages to display
│   │   │   └── Bloc/ # State Control
│   ├── News/                 # RSS feed handling and news screens
│   │   │   ├── Data/             # Data layer
│   │   │   ├── DataSources/  # API or local data sources
│   │   │   ├── Repositories/ # Implementations of repository interfaces
│   │   │   └── Models/       # Data models (DTOs)
│   │   ├── Domain/           # Domain layer (business logic)
│   │   │   ├── Entities/     # Core entities
│   │   │   ├── Usecases/     # Business logic / actions
│   │   │   └── Repositories/ # Repository interfaces
│   │   └── Presentation/     # UI screens, widgets, blocs/
│   │   │   ├── Widgets/     # Essential widgets
│   │   │   ├── Pages/     # Pages to display
│   │   │   └── Bloc/ # State Control
│   └── MyClubs/              # Followed clubs, favorites, notifications
│   │   │   ├── Data/             # Data layer
│   │   │   ├── DataSources/  # API or local data sources
│   │   │   ├── Repositories/ # Implementations of repository interfaces
│   │   │   └── Models/       # Data models (DTOs)
│   │   ├── Domain/           # Domain layer (business logic)
│   │   │   ├── Entities/     # Core entities
│   │   │   ├── Usecases/     # Business logic / actions
│   │   │   └── Repositories/ # Repository interfaces
│   │   └── Presentation/     # UI screens, widgets, blocs/
│   │   │   ├── Widgets/     # Essential widgets
│   │   │   ├── Pages/     # Pages to display
│   │   │   └── Bloc/ # State Control
├── services/                 # API + Cache layer
├── localization/             # Amharic/English string resources
└── utils/                    # Helpers (date, format, constants)


## ⚙️ Setup

1. Install [Flutter SDK](https://flutter.dev/docs/get-started/install) (≥3.0).  
2. Clone the repo:
   git clone <https://github.com/Mikreselasie/ethiofootball-mobile.git>
   cd ethiofootball-mobile
3. Install dependencies:
    flutter pub get
4. Run the app:
    flutter run
