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

                } else {

                    List {

                        ForEach(operations) { operation in

                            OperationRowView(
                                operation: operation
                            )
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

                                    viewModel.deleteOperation(
                                        operation
                                    )

                                } label: {

                                    Label(
                                        "Delete",
                                        systemImage: "trash"
                                    )
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(
                        AppTheme.background
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

                    Button {
                            showImport = true
                        } label: {
                            Image(
                                systemName: "square.and.arrow.down"
                            )
                        }
                        .accessibilityLabel("Import operations")
                    
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

                    Button {

                        showAddOperation = true

                    } label: {

                        Image(
                            systemName: "plus"
                        )
                    }
                    .accessibilityLabel(
                        "Add operation"
                    )
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
        }
    }
}

#Preview {

    OperationsView()
        .modelContainer(
            PersistenceController.preview
        )
}
