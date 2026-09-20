# S058_BudgetTracker

A lightweight and modern personal budget tracker for iPhone, built with **SwiftUI** and **SwiftData**.

The application allows users to manage their daily financial operations, organize them by category, review monthly summaries, and visualize their spending history.

## ✨ Features

* 📋 **Operations**

  * View all financial operations
  * Add, edit and delete operations
  * Store amounts in euros
  * Sort operations by date
  * Filter by category and date
  * Multi-select operations for bulk deletion

* 🏷️ **Categories**

  * View all categories alphabetically
  * Create, edit and delete categories
  * Renaming a category automatically updates associated operations
  * Deleting a category removes the category from associated operations while preserving the operations themselves

* 📊 **Monthly Recap**

  * Monthly income and expense summaries
  * Overview of financial activity by month

* 📈 **Historical Plot**

  * Visual representation of financial history
  * Helps identify spending and income trends over time

* 💾 **Local persistence**

  * Data stored locally using SwiftData
  * No account or external server required

## 🛠️ Technologies

* **Swift**
* **SwiftUI**
* **SwiftData**
* **Charts**
* **Xcode**
* **iOS**

## 🏗️ Architecture

The application follows a lightweight separation of responsibilities inspired by **MVVM** principles.

```text
S058_BudgetTracker
│
├── Models
│   ├── Operation.swift
│   └── Category.swift
│
├── Persistence
│   └── PersistenceController.swift
│
├── ViewModels
│   ├── OperationsViewModel.swift
│   └── CategoriesViewModel.swift
│
├── Views
│   ├── Operations
│   ├── Categories
│   ├── MonthlyRecap
│   └── HistoricalPlot
│
└── Resources
```

### Data model

An `Operation` contains:

* Date
* Description
* Category
* Amount

Amounts are stored internally as integer cents to avoid floating-point precision issues when handling monetary values.

A separate `Category` model maintains the application's persistent category database.

Category changes are propagated to associated operations to keep the data consistent.

## 💰 Monetary data

Financial amounts are stored as:

```swift
amountInCents: Int
```

For example:

```text
€12.50 → 1250
€100.00 → 10000
```

This avoids common floating-point precision problems associated with storing monetary values as `Double`.

## 📱 User Interface

The application uses a four-tab navigation structure:

| Tab             | Purpose                                |
| --------------- | -------------------------------------- |
| Operations      | Manage and filter financial operations |
| Monthly Recap   | Review monthly financial summaries     |
| Historical Plot | Visualize financial history            |
| Categories      | Manage operation categories            |

The interface is designed specifically for iPhone and follows standard SwiftUI interaction patterns such as swipe actions, navigation, sheets and tab navigation.

## 🧪 Development

### Requirements

* macOS
* Xcode
* iOS Simulator or a physical iPhone
* Swift / SwiftUI / SwiftData support

### Clone the repository

```bash
git clone https://github.com/OlivierMarteaux/S058_BudgetTracker.git
cd S058_BudgetTracker
```

Then open the Xcode project:

```text
S058_BudgetTracker.xcodeproj
```

Select an iOS Simulator or connected iPhone and run the application from Xcode.

## 🔐 Data & Privacy

Budget data is stored locally on the device using SwiftData.

The application does not require a user account or a remote backend for its core functionality.

No financial information needs to leave the device.

## 🚧 Project Status

This project is actively developed as part of my transition from **16 years of engineering and product architecture in the aerospace industry to iOS and mobile software development**.

It is also used as a practical project to explore the Apple development ecosystem, including:

* Swift
* SwiftUI
* SwiftData
* Xcode
* iOS development
* Widget development
* App Groups
* Modern Apple platform architecture

## 🎯 Learning Objectives

The project provides hands-on experience with:

* Building applications with SwiftUI
* Managing application state
* Designing reusable SwiftUI views
* Persisting data with SwiftData
* Working with observable view models
* Building data-driven interfaces
* Managing relationships between persisted data
* Creating charts with Apple's Charts framework
* Developing and testing on physical iOS devices
* Integrating an iOS Widget extension

## 👨‍💻 Author

**Olivier Marteaux**

Android & iOS Developer
Former aerospace Product Architect

* Portfolio: https://oliviermarteaux.dev
* GitHub: https://github.com/OlivierMarteaux
* LinkedIn: https://www.linkedin.com/in/olivier-marteaux/

## 📄 License

This project is available for educational and portfolio purposes.

