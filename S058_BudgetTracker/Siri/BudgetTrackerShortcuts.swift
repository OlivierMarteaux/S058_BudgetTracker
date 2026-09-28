//
//  BudgetTrackerShortcuts.swift
//  S058_BudgetTracker
//
//  Created by Olivier Marteaux on 24/09/2026.
//


import AppIntents

struct BudgetTrackerShortcuts: AppShortcutsProvider {

    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddOperationIntent(),
            phrases: [
                "Ajouter une dépense dans \(.applicationName)",
                "Dans \(.applicationName), ajoute une dépense.",
                "Ajoute une dépense dans \(.applicationName)",
            ],
            shortTitle: "Ajouter une dépense dans Budget Tracker",
            systemImageName: "plus.circle"
        )
    }
}
