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
    
    @Query(
        sort: [
            SortDescriptor(
                \Category.name
            )
        ]
    )
    private var categories: [Category]
    
    @State private var showMonthlyTotal = true

    @State private var visibleCategoryIDs: Set<UUID> = []
    
    private var monthlyCategoryTotals:
        [MonthlyCategoryTotal] {

        viewModel.monthlyCategoryTotals(
            from: operations,
            categories: categories
        )
    }
    
    private let categoryColors: [Color] = [
        .blue,
        .green,
        .orange,
        .purple,
        .pink,
        .teal,
        .indigo,
        .red,
        .mint,
        .cyan,
        .yellow,
        .brown,
        .gray,
        .blue.opacity(0.65),
        .green.opacity(0.65),
        .orange.opacity(0.65),
        .purple.opacity(0.65),
        .pink.opacity(0.65),
        .teal.opacity(0.65),
        .indigo.opacity(0.65),
        .red.opacity(0.65),
        .mint.opacity(0.65),
        .cyan.opacity(0.65),
        .yellow.opacity(0.65),
        .brown.opacity(0.65)
    ]
    
    private func color(
        for index: Int
    ) -> Color {

        categoryColors[
            index % categoryColors.count
        ]
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

                        Chart {

                            // MARK: Monthly total

                            if showMonthlyTotal {

                                ForEach(monthlyTotals) { monthlyTotal in

                                    LineMark(
                                        x: .value(
                                            "Month",
                                            monthlyTotal.month
                                        ),
                                        y: .value(
                                            "Amount",
                                            monthlyTotal.total
                                        ),
                                        series: .value(
                                            "Series",
                                            "monthly-total"
                                        )
                                    )
                                    .foregroundStyle(
                                        AppTheme.primaryBlue
                                    )
                                    .symbol(Circle())
                                }

                                if let budgetInCents =
                                    budgetStore.budgetInCents {

                                    RuleMark(
                                        y: .value(
                                            "Budget",
                                            Double(budgetInCents) / 100
                                        )
                                    )
                                    .foregroundStyle(
                                        AppTheme.primaryBlue
                                    )
                                    .lineStyle(
                                        StrokeStyle(
                                            lineWidth: 2,
                                            dash: [6, 4]
                                        )
                                    )
                                }
                            }

                            // MARK: Categories

                            ForEach(
                                Array(categories.enumerated()),
                                id: \.element.id
                            ) { index, category in

                                if visibleCategoryIDs.contains(
                                    category.id
                                ) {

                                    let color = color(
                                        for: index
                                    )

                                    ForEach(
                                        monthlyCategoryTotals.filter {
                                            $0.category.id == category.id
                                        }
                                    ) { monthlyCategory in
                                        
                                        let seriesID =
                                            "category-\(category.id.uuidString)"

                                        LineMark(
                                            x: .value(
                                                "Month",
                                                monthlyCategory.month
                                            ),
                                            y: .value(
                                                "Amount",
                                                monthlyCategory.total
                                            ),
                                            series: .value(
                                                "Series",
                                                seriesID
                                            )
                                        )
                                        .foregroundStyle(color)
                                        .symbol(Circle())
                                    }

                                    if let budgetInCents =
                                        category.budgetInCents {

                                        RuleMark(
                                            y: .value(
                                                "Budget",
                                                Double(budgetInCents) / 100
                                            )
                                        )
                                        .foregroundStyle(color)
                                        .lineStyle(
                                            StrokeStyle(
                                                lineWidth: 2,
                                                dash: [6, 4]
                                            )
                                        )
                                    }
                                }
                            }
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
                        
                        Button {

                            showMonthlyTotal.toggle()

                        } label: {

                            Text("Monthly total")
                                .font(.body)
                                .fontWeight(.medium)
                                .frame(
                                    maxWidth: .infinity
                                )
                                .padding(.vertical, 14)
                                .background(
                                    showMonthlyTotal
                                        ? AppTheme.primaryBlue
                                    : AppTheme.cardBackground
                                )
                                .foregroundStyle(
                                    showMonthlyTotal ? .white : .primary
                                )
                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius:
                                            AppTheme.cornerRadius
                                    )
                                )
                        }
                        .buttonStyle(.plain)
                        
                        
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ],
                            spacing: 8
                        ) {

                            ForEach(
                                Array(categories.enumerated()),
                                id: \.element.id
                            ) { index, category in

                                let isVisible =
                                    visibleCategoryIDs.contains(
                                        category.id
                                    )

                                let categoryColor =
                                    color(for: index)

                                Button {

                                    if isVisible {
                                        visibleCategoryIDs.remove(
                                            category.id
                                        )
                                    } else {
                                        visibleCategoryIDs.insert(
                                            category.id
                                        )
                                    }

                                } label: {

                                    Text(category.name)
                                        .font(.body)
                                        .fontWeight(.medium)
                                        .lineLimit(1)
                                        .frame(
                                            maxWidth: .infinity
                                        )
                                        .padding(.vertical, 14)
                                        .background(
                                            isVisible
                                                ? categoryColor
                                            : AppTheme.cardBackground
                                        )
//                                        .foregroundStyle(.white)
                                        .clipShape(
                                            RoundedRectangle(
                                                cornerRadius:
                                                    AppTheme.cornerRadius
                                            )
                                        )
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel(
                                    "\(category.name), \(isVisible ? "visible" : "hidden")"
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .background(
                        AppTheme.background
                    )
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
