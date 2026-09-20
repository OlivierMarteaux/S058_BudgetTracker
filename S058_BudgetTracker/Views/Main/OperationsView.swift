//
//  OperationsView.swift
//  BudgetTracker
//

import SwiftUI
import SwiftData

struct OperationsView: View {

    @Environment(\.modelContext)
    private var modelContext
    
    @Binding var showAddOperation: Bool

    @Query(
        sort: [
            SortDescriptor(
                \Operation.date,
                order: .reverse
            )
        ]
    )
    private var operations: [Operation]

    @State private var operationToEdit: Operation?
    @State private var showExport = false
    @State private var showImport = false
    
    @State private var showFilter = false

    @State private var selectedCategory =
        "All Categories"

    @State private var selectedDateFilter:
        OperationDateFilter = .all
    
    @State private var isSelecting = false
    @State private var selectedOperationIDs: Set<UUID> = []
    
    private var categories: [String] {

        Array(
            Set(
                operations.map { $0.category }
            )
        )
        .filter { !$0.isEmpty }
        .sorted()
    }

    private var filteredOperations: [Operation] {

        operations.filter { operation in

            let categoryMatches =
                selectedCategory == "All Categories"
                || operation.category == selectedCategory

            let dateMatches =
                matchesDateFilter(
                    operation.date
                )

            return categoryMatches && dateMatches
        }
    }

    private var isFilterActive: Bool {

        selectedCategory != "All Categories"
            || selectedDateFilter != .all
    }
    
    private func matchesDateFilter(
        _ date: Date
    ) -> Bool {

        let calendar = Calendar.current

        switch selectedDateFilter {

        case .all:
            return true

        case .thisMonth:

            return calendar.isDate(
                date,
                equalTo: Date(),
                toGranularity: .month
            )

        case .lastMonth:

            guard let lastMonth = calendar.date(
                byAdding: .month,
                value: -1,
                to: Date()
            ) else {
                return false
            }

            return calendar.isDate(
                date,
                equalTo: lastMonth,
                toGranularity: .month
            )

        case let .custom(from, to):

            let startOfDay = calendar.startOfDay(
                for: from
            )

            guard let endOfDay = calendar.date(
                bySettingHour: 23,
                minute: 59,
                second: 59,
                of: to
            ) else {
                return false
            }

            return date >= startOfDay
                && date <= endOfDay
        }
    }
    
    private func deleteSelectedOperations() {

        let selectedOperations = filteredOperations.filter {
            selectedOperationIDs.contains($0.id)
        }

        viewModel.deleteOperations(
            selectedOperations
        )

        selectedOperationIDs.removeAll()
        isSelecting = false
    }
    
    private func deleteOperation(
        _ operation: Operation
    ) {
        viewModel.deleteOperation(operation)
    }
    
    init(
        showAddOperation: Binding<Bool> = .constant(false)
    ) {
        _showAddOperation = showAddOperation
    }

    private var viewModel: OperationsViewModel {
        OperationsViewModel(
            modelContext: modelContext
        )
    }

    var body: some View {

        NavigationStack {

            Group {

                if operations.isEmpty {

                    EmptyStateView(
                        title: "No operations",
                        message:
                            "Add your first operation using the + button."
                    )

                } else if filteredOperations.isEmpty {

                    EmptyStateView(
                        title: "No matching operations",
                        message:
                            "No operations match the current filters."
                    )

                } else {

                    List(selection: $selectedOperationIDs) {
                        ForEach(filteredOperations) { operation in

                            OperationRowView(
                                operation: operation
                            )
                            .tag(operation.id)
                            .listRowInsets(
                                EdgeInsets(
                                    top: 5,
                                    leading: 16,
                                    bottom: 5,
                                    trailing: 16
                                )
                            )
                            .listRowSeparator(.hidden)
                            .listRowBackground(
                                Color.clear
                            )
                            .swipeActions(
                                edge: .leading,
                                allowsFullSwipe: false
                            ) {

                                Button {
                                    operationToEdit = operation
                                } label: {

                                    Label(
                                        "Edit",
                                        systemImage: "pencil"
                                    )
                                }
                                .tint(
                                    AppTheme.secondaryBlue
                                )
                            }
                            .swipeActions(
                                edge: .trailing,
                                allowsFullSwipe: true
                            ) {

                                Button(
                                    role: .destructive
                                ) {
                                    deleteOperation(operation)
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                        }
                    }
                    .environment(
                        \.editMode,
                        .constant(
                            isSelecting
                            ? EditMode.active
                            : EditMode.inactive
                        )
                    )
                }
            }
            .background(
                AppTheme.background
            )
            .navigationTitle("Operations")
            .toolbar {

                ToolbarItemGroup(
                    placement: .topBarTrailing
                ) {

                    if isSelecting {

                        Button {

                            deleteSelectedOperations()

                        } label: {

                            Image(
                                systemName: "trash"
                            )
                        }
                        .disabled(
                            selectedOperationIDs.isEmpty
                        )
                        .accessibilityLabel(
                            "Delete selected operations"
                        )

                        Button("Done") {

                            isSelecting = false
                            selectedOperationIDs.removeAll()
                        }
                    } else {

                        Button {

                            isSelecting = true

                        } label: {

                            Image(
                                systemName: "checklist"
                            )
                        }
                        .accessibilityLabel(
                            "Select operations"
                        )

                        Button {

                            showFilter = true

                        } label: {

                            Image(
                                systemName:
                                    isFilterActive
                                    ? "line.3.horizontal.decrease.circle.fill"
                                    : "line.3.horizontal.decrease.circle"
                            )
                        }
                        .accessibilityLabel(
                            "Filter operations"
                        )

                        Button {

                            showImport = true

                        } label: {

                            Image(
                                systemName:
                                    "square.and.arrow.down"
                            )
                        }
                        .accessibilityLabel(
                            "Import operations"
                        )

                        Button {

                            showExport = true

                        } label: {

                            Image(
                                systemName:
                                    "square.and.arrow.up"
                            )
                        }
                        .accessibilityLabel(
                            "Export operations"
                        )

//                        Button {
//
//                            showAddOperation = true
//
//                        } label: {
//
//                            Image(
//                                systemName: "plus"
//                            )
//                        }
//                        .accessibilityLabel(
//                            "Add operation"
//                        )
                    }
                }
            }
            .overlay(
                alignment: .bottomTrailing
            ) {

                FloatingActionButton {

                    showAddOperation = true
                }
                .padding(20)
            }
            .sheet(
                isPresented: $showAddOperation
            ) {

                OperationEditorView {

                    date,
                    description,
                    amountInCents,
                    category in

                    viewModel.addOperation(
                        date: date,
                        description: description,
                        amountInCents: amountInCents,
                        category: category
                    )
                }
            }
            .sheet(
                item: $operationToEdit
            ) { operation in

                OperationEditorView(
                    operation: operation
                ) {

                    date,
                    description,
                    amountInCents,
                    category in

                    viewModel.updateOperation(
                        operation,
                        date: date,
                        description: description,
                        amountInCents: amountInCents,
                        category: category
                    )
                }
            }
            .sheet(
                isPresented: $showExport
            ) {

                ExportOperationsView()
            }
            .sheet(
                isPresented: $showImport
            ) {
                ImportOperationsView()
            }
            .sheet(
                isPresented: $showFilter
            ) {

                OperationFilterView(
                    category: $selectedCategory,
                    dateFilter: $selectedDateFilter,
                    categories: categories
                )
            }
        }
    }
}

#Preview {

    OperationsView()
        .modelContainer(
            PersistenceController.preview
        )
}
