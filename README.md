# Flutter Clean Architecture Demo

This project is a technical proof of concept demonstrating Clean Architecture in Flutter, using Cubit for state management, Hive for local persistence, and Dio for API consumption.

## Features

- **Clean Architecture**: Strictly separated into Presentation, Domain, and Data layers.
- **State Management**: `flutter_bloc` (Cubit).
- **Local Persistence**: `hive` for storing favorite items.
- **API Consumption**: `dio` to fetch data from PokéAPI.
- **Navigation**: `go_router` for declarative routing.
- **Dependency Injection**: `get_it` for service locator pattern.
- **Functional Programming**: `dartz` for `Either` type in UseCases.

## Architecture

The project follows the Clean Architecture principles:

1.  **Presentation Layer**: UI (Widgets, Pages) and State Management (Cubits). Depends on Domain.
2.  **Domain Layer**: Business Logic (Entities, UseCases, Repository Interfaces). Pure Dart, no dependencies on Flutter or Data.
3.  **Data Layer**: Data retrieval (Repositories Implementation, Datasources, Models). Depends on Domain.

### Folder Structure

```
lib/
├── core/                   # Shared code (Constants, Errors, Utils)
├── features/
│   └── items/
│       ├── data/           # Data Layer
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/         # Domain Layer
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/   # Presentation Layer
│           ├── cubit/
│           ├── pages/
│           └── widgets/
├── injection_container.dart # DI Setup
└── main.dart               # Entry Point
```

## Getting Started

1.  **Clone the repository**:
    ```bash
    git clone <repo-url>
    cd flutter_clean_arch_demo
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run Code Generation** (for Hive adapters):
    ```bash
    flutter pub run build_runner build
    ```

4.  **Run the app**:
    ```bash
    flutter run
    ```

## Screens

-   **/api-list**: Displays a list of items fetched from the API.
-   **/prefs**: Displays a list of locally saved items.
-   **/prefs/new**: Screen to save a selected item with a custom name.
-   **/prefs/:id**: Detailed view of a saved item.

## Future Improvements

-   Add Unit Tests for Cubits and UseCases.
-   Implement proper error handling with user-friendly messages.
-   Add pagination for the API list.
-   Improve UI design with a proper theme.
