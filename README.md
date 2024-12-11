# iOS Pokedex: A Handheld Electronic Encyclopedia about Pokémon

## Overview

This is an iOS app designed to demonstrate skills in consuming REST APIs, specifically the [PokeAPI](https://pokeapi.co), which provides data on Pokémon. The app allows users to explore Pokémon data, search for specific Pokémon, and view detailed information about them.

The project is ongoing, and while several key features are already implemented, there are still more modules and enhancements to come. You may notice some incomplete or placeholder screens.

## Features

### 1. **Home Module**
   - Displays all available Pokémon in a two-column grid.
   - Implements **pagination** to avoid loading all Pokémon at once.
   - **Search functionality**: Search Pokémon by name.
   - **Offline Support**: Saves downloaded Pokémon locally, allowing users to access them even without an internet connection.
   - **Retry Mechanism**: If data retrieval fails, a retry button is provided to re-initiate the download.
   - **Detail View**: Tapping on a Pokémon will navigate to a detailed screen showing more information.

   [Example Video](https://github.com/cerezo074/pokemon-api/assets/6471815/9c49186b-8ce8-488b-a2d5-5deab8dbec1e)

### 2. **Sign In/Sign Out Simulation**
   - Users can sign in and out of the app, though the current implementation is simulated.
   - **Task Simulation**: A `Task.sleep(5 seconds)` is used to simulate a long-running process for sign-in and sign-out routines. This will later be replaced with actual authentication logic.

### 3. **Splash Screen & App Initialization**
   - The app features a splash animation that is displayed during the initial app launch.
   - **Simulated Initialization**: A 5-second delay (using `Task.sleep`) mimics loading dependencies such as feature flags or user experiments based on external configurations. In a future release, this will be replaced with actual calls to load remote configurations and features.

### 4. **Onboarding Flow**
   - After the splash screen, users are guided through an onboarding process designed to introduce them to the app’s features and functionality.
   - **Hardcoded Persistence**: Currently, the onboarding flow is controlled by a hardcoded flag that determines whether the user should go through it. This will eventually be replaced with dynamic persistence based on user data or external configuration.
   - The onboarding flow ensures that users are introduced to key features before accessing the app’s main content.

### 5. **Guest User Support & Sign-In Requirement**
   - The app allows users to launch it either as a **Guest** or by requiring a **Sign-In**.
   - **Guest User Mode**: A boolean flag `isGuestUserAllowed` controls whether the app allows guest access or prompts for sign-in immediately upon launch. This flag is currently hardcoded but can be configured dynamically through external settings.

## Technical Details

### Data Handling
- Pokémon data is fetched using the [PokemonAPI](https://github.com/kinkofer/PokemonAPI) library.
- To show Pokémon images alongside the list, two API endpoints are called:
   1. **List Endpoint**: Retrieves names and URLs for Pokémon.
   2. **Info Endpoint**: Fetches detailed information, including the large Pokémon images.
   - The library was **forked and enhanced** to support large Pokémon images and improved pagination handling (see [fork](a5bd7587c29aa371382277e24737d162ae6a84f0)).
   - Local storage is handled using the device's **Documents folder**, with asynchronous fetching to prevent blocking the main thread.

### Architecture

The app follows the **MVVM (Model-View-ViewModel)** architecture for simplicity, scalability, and testability.

- **Navigation**: The app uses a hierarchical, stateless navigation model. At the top level, the `AppNavigation` component controls app-wide navigation. Each module has its own navigation component but relies on the app's central navigation to handle transitions. This approach makes future module additions easy and flexible.
- **Observable Object**: The main navigation object conforms to `ObservableObject`, allowing the app's navigation state to be updated based on changes (e.g., login/logout/splash/onboarding...).

   Example of dynamic root screen based on authentication status:

   ```swift
   @ViewBuilder
   func makeRootScreen() -> some View {
       if (!authModule.isSessionValid) {
           authNavigation.start() // Navigate to login
       } else {
           homeNavigation.start() // Navigate to home
       }
   }
   ```

## Next Steps

While the core features are in place, several enhancements and new features are planned:

### 1. **Testing**
   - **Increase code coverage**: Currently, the Remote Data Repository is the only fully tested class (using URLProtocol to mock network calls). Testing ViewModels and other components will follow as they rely on injected contracts (protocols or interfaces).
   - Aim to cover more aspects of the app, especially complex logic.

### 2. **Query Mechanism**
   - **Improved data filtering**: The app requires more flexible filtering options. Implementing a query mechanism (such as Core Data or another query library) will make it easier to scale the app and add new filter criteria in the future.
   - **Core Data Integration**: A Core Data template is included, but other query libraries can also be used.

### 3. **New Modules**
   - The app is still in development, and additional modules are planned for future releases, including features like Pokémon abilities, types, and stats.

## Installation

To install and run this project locally, follow these steps:

1. Clone this repository:
   ```bash
   git clone https://github.com/cerezo074/pokemon-api.git
   ```
2. Open the project in Xcode:
   ```bash
   open iOS-Pokedex.xcodeproj
   ```
3. Build and run the project using the simulator or a connected device.

## Contributing

Feel free to contribute to the project! Here's how you can get involved:
- **Open an Issue**: If you spot a bug or have a feature request, open an issue.
- **Submit a Pull Request**: If you'd like to contribute a new feature or fix a bug, fork the repository and submit a pull request.
