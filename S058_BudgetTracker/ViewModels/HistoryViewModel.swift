//
//  HistoryViewModel.swift
//  S058_BudgetTracker
//
//  Created by Olivier Marteaux on 10/09/2026.
//

import Foundation
import Combine

@MainActor
final class HistoryViewModel: ObservableObject {

    private let monthlyRecapViewModel =
        MonthlyRecapViewModel()

    func monthlyTotals(
        from operations: [Operation]
    ) -> [MonthlyTotal] {

        monthlyRecapViewModel.monthlyTotals(
            from: operations
        )
        .sorted {
            $0.month < $1.month
        }
    }
}
