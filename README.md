
# Rick and Morty iOS

This is a simple iOS app that fetches and displays characters from the Rick and Morty API. It utilizes SwiftUI for the user interface and Realm for local data persistence.

## Architecture

The app follows an MVVM (Model-View-ViewModel) design pattern with **Coordinators** for managing navigation. Coordinators help manage view controller flow, decoupling navigation logic from views and view models.

### Coordinator Usage:
- **Navigation Management**: Coordinators are used to handle view transitions. Instead of embedding navigation logic in views, coordinators are responsible for controlling the flow between screens.
- **Decoupling Views**: This structure allows for cleaner, more testable code, where views are independent of navigation concerns.

## Installation

1. Clone the repo:
   ```bash
   git clone https://github.com/darkandchoco/rickandmorty-ios.git
   ```

2. Install dependencies using Xcode's `Swift Package Manager` or any other package manager.

3. Run the app in the simulator or on a physical device.

## App Flow
1. **Main View**: Displays a list of characters fetched from the API or local Realm database.
2. **Character Row View**: Each row shows a character's basic info such as name and status.
3. **Realm Integration**: Data is persisted locally using Realm for offline capabilities.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
