# 📰 News Topic Explorer (Advanced Architecture)

An enterprise-grade news aggregation application built with **Flutter**, implementing **Clean Architecture** principles and the **BLoC pattern** for scalable state management.

This project demonstrates a production-ready approach to mobile development, featuring a strict separation of concerns, robust error handling, and a fully decoupled Data Layer.

---

## 🚀 Key Features

* **Event-Driven State Management:** powered by `flutter_bloc` to handle complex UI states (Loading, Loaded, Error).
* **Clean Architecture:** Strict separation into **Data**, **Domain**, and **Presentation** layers.
* **Repository Pattern:** Abstracted data layer allowing for easy swapping of data sources (e.g., GNews vs NewsData).
* **Smart Search:** Real-time search functionality with **Debouncing** to optimize API usage.
* **In-App Web Browser:** Integrated `webview_flutter` for seamless article reading.
* **Advanced Networking:** Uses `dio` for robust HTTP requests, interceptors, and error logging.
* **Category Filtering:** Dynamic content switching based on news topics.


---


## 🏗️ Architecture & Design

This project follows the **MVVM (Model-View-ViewModel)** pattern implemented via **BLoC**.

### The Clean Architecture Layers
1.  **Domain Layer (Inner Circle):** Contains **Entities** (Pure Dart classes) and **Abstract Repositories** (`INewsRepository`). This layer depends on *nothing*.
2.  **Data Layer:** Contains **Models** (JSON serialization), **Data Sources** (API calls), and **Concrete Repositories**. This layer implements the Domain contracts.
3.  **Presentation Layer:** Contains **BLoCs** (Logic), **Events**, **States**, and **UI Widgets**.

```mermaid
graph TD
    UI[UI Widgets] -- "Adds Event" --> Bloc
    Bloc -- "Emits State" --> UI
    Bloc -- "Calls" --> UseCase
    UseCase -- "Calls" --> RepositoryInterface
    RepositoryImpl -- "Implements" --> RepositoryInterface
    RepositoryImpl -- "Uses" --> RemoteDataSource



