import Foundation
import Combine

struct MonthlyCategoryTotal: Identifiable {

    let id: String
    let month: Date
    let category: Category
    let totalInCents: Int

    var total: Double {
        Double(totalInCents) / 100
    }

    var budget: Double? {
        category.budgetInCents.map {
            Double($0) / 100
        }
    }
}

@MainActor
final class HistoryViewModel: ObservableObject {

    private let monthlyRecapViewModel =
        MonthlyRecapViewModel()

    func monthlyTotals(
        from operations: [Operation]
    ) -> [MonthlyTotal] {

        monthlyRecapViewModel
            .monthlyTotals(from: operations)
            .sorted {
                $0.month < $1.month
            }
    }

    func monthlyCategoryTotals(
        from operations: [Operation],
        categories: [Category]
    ) -> [MonthlyCategoryTotal] {

        let calendar = Calendar.current

        let grouped = Dictionary(
            grouping: operations
        ) { operation in

            calendar.date(
                from: calendar.dateComponents(
                    [.year, .month],
                    from: operation.date
                )
            )!
        }

        var result: [MonthlyCategoryTotal] = []

        for (month, monthOperations) in grouped {

            for category in categories {

                let total = monthOperations
                    .filter {
                        $0.category == category.name
                    }
                    .reduce(0) {
                        $0 + $1.amountInCents
                    }

                result.append(
                    MonthlyCategoryTotal(
                        id: "\(category.id)-\(month.timeIntervalSince1970)",
                        month: month,
                        category: category,
                        totalInCents: total
                    )
                )
            }
        }

        return result.sorted {
            $0.month < $1.month
        }
    }
}
