//
//  HistoryChartView.swift
//  S058_BudgetTracker
//
//  Created by Olivier Marteaux on 10/09/2026.
//

import SwiftUI
import SwiftData
import Charts

struct HistoryChartView: View {

    @Query(
        sort: [
            SortDescriptor(
                \Operation.date
            )
        ]
    )
    private var operations: [Operation]

    private let viewModel =
        HistoryViewModel()

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
                        title: "No history yet",
                        message:
                            "Your monthly history will appear here."
                    )

                } else {

                    ScrollView {

                        Chart(monthlyTotals) {
                            monthlyTotal in

                            BarMark(
                                x: .value(
                                    "Month",
                                    monthlyTotal.month
                                ),
                                y: .value(
                                    "Total",
                                    Double(
                                        monthlyTotal.totalInCents
                                    ) / 100
                                )
                            )
                            .foregroundStyle(
                                AppTheme.primaryBlue
                            )
                            .cornerRadius(5)
                        }
                        .frame(
                            height: 320
                        )
                        .chartYAxis {
                            AxisMarks(
                                position: .leading
                            )
                        }
                        .chartXAxis {

                            AxisMarks(
                                values: .stride(
                                    by: .month
                                )
                            ) {

                                AxisGridLine()
                                AxisTick()

                                AxisValueLabel(
                                    format:
                                        .dateTime
                                        .month(
                                            .abbreviated
                                        )
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle(
                "History"
            )
        }
    }
}

#Preview {

    HistoryChartView()
        .modelContainer(
            PersistenceController.preview
        )
}
