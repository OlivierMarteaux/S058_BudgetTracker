//
//  BudgetTrackerApp.swift
//  BudgetTracker
//

import SwiftUI
import SwiftData

@main
struct S058_BudgetTrackerApp: App {

    private let modelContainer =
        PersistenceController.shared

    @State private var selectedTab:
        AppTab = .operations
    
    @State private var showAddOperation = false

    var body: some Scene {

        WindowGroup {

            TabView(
                selection: $selectedTab
            ) {

                OperationsView(
                    showAddOperation: $showAddOperation
                )
                    .tabItem {

                        Label(
                            "Operations",
                            systemImage:
                                "list.bullet.rectangle"
                        )
                    }
                    .tag(
                        AppTab.operations
                    )

                MonthlyRecapView()
                    .tabItem {

                        Label(
                            "Recap",
                            systemImage:
                                "calendar"
                        )
                    }
                    .tag(
                        AppTab.recap
                    )

                HistoryChartView()
                    .tabItem {

                        Label(
                            "History",
                            systemImage:
                                "chart.xyaxis.line"
                        )
                    }
                    .tag(
                        AppTab.history
                    )
                
                CategoriesView()
                    .tabItem {
                        
                        Label(
                            "Categories",
                            systemImage: "folder"
                        )
                    }
                    .tag(
                        AppTab.categories
                    )
            }
            .onOpenURL { url in

                if url.scheme == "budgettracker",
                   url.host == "add-operation" {

                    selectedTab = .operations
                    showAddOperation = true
                }
            }
        }
        .modelContainer(
            modelContainer
        )
    }
}
