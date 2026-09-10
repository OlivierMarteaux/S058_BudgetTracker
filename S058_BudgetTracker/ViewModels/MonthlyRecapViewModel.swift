//
//  MonthlyRecapViewModel.swift
//  BudgetTracker
//

import Foundation
import Combine

struct MonthlyTotal: Identifiable {

    let id: Date
    let month: Date
    let totalInCents: Int

    var total: Decimal {
        Decimal(totalInCents) / 100
    }

    var formattedTotal: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        formatter.locale = Locale(identifier: "fr_FR")

        return formatter.string(
            from: NSDecimalNumber(decimal: total)
        ) ?? "\(totalInCents) €"
    }
}

@MainActor
final class MonthlyRecapViewModel: ObservableObject {

    func monthlyTotals(
        from operations: [Operation]
    ) -> [MonthlyTotal] {

        let calendar = Calendar.current

        let grouped = Dictionary(
            grouping: operations
        ) { operation in
            calendar.date(
                from: calendar.dateComponents(
                    [.year, .month],
                    from: operation.date
                )
            ) ?? operation.date
        }

        return grouped
            .map { month, operations in

                let total = operations.reduce(
                    0
                ) { partialResult, operation in
                    partialResult + operation.amountInCents
                }

                return MonthlyTotal(
                    id: month,
                    month: month,
                    totalInCents: total
                )
            }
            .sorted {
                $0.month > $1.month
            }
    }
}
