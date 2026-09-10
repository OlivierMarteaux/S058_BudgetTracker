//
//  MonthlyRecapView.swift
//  S058_BudgetTracker
//
//  Created by Olivier Marteaux on 10/09/2026.
//

import SwiftUI
import SwiftData

struct MonthlyRecapView: View {

    @Query(
        sort: [
            SortDescriptor(
                \Operation.date,
                order: .reverse
            )
        ]
    )
    private var operations: [Operation]

    private let viewModel =
        MonthlyRecapViewModel()

    private var monthlyTotals: [MonthlyTotal] {

        viewModel.monthlyTotals(
            from: operations
        )
    }

    var body: some View {

        NavigationStack {

            Group {

                if monthlyTotals.isEmpty {

                    EmptyStateView(
                        title: "No recap yet",
                        message:
                            "Monthly totals will appear here once you add operations."
                    )

                } else {

                    List(monthlyTotals) {
                        monthlyTotal in

                        HStack {

                            Text(
                                monthlyTotal.month,
                                format: .dateTime
                                    .month(.wide)
                                    .year()
                            )
                            .fontWeight(.medium)

                            Spacer()

                            Text(
                                monthlyTotal.formattedTotal
                            )
                            .fontWeight(.semibold)
                            .foregroundStyle(
                                monthlyTotal.totalInCents >= 0
                                    ? AppTheme.positive
                                    : AppTheme.negative
                            )
                        }
                        .padding(.vertical, 6)
                    }
                    .listStyle(
                        .insetGrouped
                    )
                }
            }
            .navigationTitle(
                "Monthly recap"
            )
        }
    }
}

#Preview {

    MonthlyRecapView()
        .modelContainer(
            PersistenceController.preview
        )
}
