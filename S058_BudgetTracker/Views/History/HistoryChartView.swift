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
    
    @StateObject private var budgetStore: UserBudgetStore =
        UserBudgetStore()

    @State private var showUserBudget = false

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
                            
                            if let budgetInCents =
                                budgetStore.budgetInCents {

                                RuleMark(
                                    y: .value(
                                        "Budget",
                                        Double(budgetInCents) / 100
                                    )
                                )
                                .foregroundStyle(.red)
                                .lineStyle(
                                    StrokeStyle(
                                        lineWidth: 2,
                                        dash: [6, 4]
                                    )
                                )
                                .annotation(
                                    position: .top,
                                    alignment: .leading
                                ) {
                                    Text(
                                        "Budget"
                                    )
                                    .font(.caption)
                                    .foregroundStyle(.red)
                                }
                            }

//                            BarMark(
//                                x: .value(
//                                    "Month",
//                                    monthlyTotal.month
//                                ),
//                                y: .value(
//                                    "Total",
//                                    Double(
//                                        monthlyTotal.totalInCents
//                                    ) / 100
//                                )
//                            )
//                            .foregroundStyle(
//                                AppTheme.primaryBlue
//                            )
//                            .cornerRadius(5)
                            LineMark(
                                x: .value("Month", monthlyTotal.month),
                                y: .value("Amount", monthlyTotal.total)
                            )
//                            .interpolationMethod(.catmullRom)
                            .symbol(Circle())
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
            .toolbar {

                ToolbarItem(
                    placement: .topBarTrailing
                ) {

                    Button {
                        showUserBudget = true
                    } label: {
                        Image(
                            systemName: "banknote"
                        )
                    }
                    .accessibilityLabel(
                        "User Budget"
                    )
                }
            }
            .sheet(
                isPresented: $showUserBudget
            ) {
                UserBudgetView(
                    budgetStore: budgetStore
                )
            }
        }
    }
}

//#Preview {
//
//    HistoryChartView()
//        .modelContainer(
//            PersistenceController.preview
//        )
//}
