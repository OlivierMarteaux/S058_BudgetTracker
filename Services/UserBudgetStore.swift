//
//  UserBudgetStore.swift
//  S058_BudgetTracker
//
//  Created by Olivier Marteaux on 20/09/2026.
//


import Foundation
import Combine

@MainActor
final class UserBudgetStore: ObservableObject {

    private let budgetKey = "userMonthlyBudgetInCents"

    @Published private(set) var budgetInCents: Int?

    init() {
        let defaults = UserDefaults.standard

        if defaults.object(
            forKey: budgetKey
        ) != nil {

            budgetInCents = defaults.integer(
                forKey: budgetKey
            )
        }
    }

    func setBudget(
        amountInCents: Int
    ) {

        UserDefaults.standard.set(
            amountInCents,
            forKey: budgetKey
        )

        budgetInCents = amountInCents
    }

    func clearBudget() {

        UserDefaults.standard.removeObject(
            forKey: budgetKey
        )

        budgetInCents = nil
    }
}
