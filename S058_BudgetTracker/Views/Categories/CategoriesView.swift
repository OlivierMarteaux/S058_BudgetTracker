//
//  CategoriesView.swift
//  S058_BudgetTracker
//
//  Created by Olivier Marteaux on 20/09/2026.
//


import SwiftUI
import SwiftData

struct CategoriesView: View {

    @Environment(\.modelContext)
    private var modelContext

    @Query(
        sort: [
            SortDescriptor(
                \Category.name
            )
        ]
    )
    private var categories: [Category]

    @State private var showAddCategory = false
    @State private var categoryToEdit: Category?

    private var viewModel: CategoriesViewModel {
        CategoriesViewModel(
            modelContext: modelContext
        )
    }

    var body: some View {

        NavigationStack {

            Group {

                if categories.isEmpty {

                    EmptyStateView(
                        title: "No categories",
                        message:
                            "Create your first category using the + button."
                    )

                } else {

                    List {

                        ForEach(categories) { category in

                            Text(category.name)
//                                .listRowInsets(
//                                    EdgeInsets(
//                                        top: 8,
//                                        leading: 16,
//                                        bottom: 8,
//                                        trailing: 16
//                                    )
//                                )
//                                .listRowSeparator(.hidden)
//                                .listRowBackground(
//                                    Color.clear
//                                )
                                .font(.body)
                                .fontWeight(.medium)
                                .lineLimit(1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                                .background(
                                    AppTheme.cardBackground
                                )
                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius: AppTheme.cornerRadius
                                    )
                                )
                                .overlay(
                                    RoundedRectangle(
                                        cornerRadius: AppTheme.cornerRadius
                                    )
                                    .stroke(
                                        Color.primary.opacity(0.08),
                                        lineWidth: 1
                                    )
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

                                        categoryToEdit =
                                            category

                                    } label: {

                                        Label(
                                            "Edit",
                                            systemImage:
                                                "pencil"
                                        )
                                    }
                                    .tint(
                                        AppTheme.secondaryBlue
                                    )
                                }
                                .swipeActions(
                                    edge: .trailing,
                                    allowsFullSwipe: false
                                ) {

                                    Button(
                                        role: .destructive
                                    ) {

                                        viewModel.deleteCategory(
                                            category
                                        )

                                    } label: {

                                        Label(
                                            "Delete",
                                            systemImage:
                                                "trash"
                                        )
                                    }
                                }
                        }
                    }
                }
            }
            .background(
                AppTheme.background
            )
            .navigationTitle("Categories")
            .toolbar {

                ToolbarItem(
                    placement: .topBarTrailing
                ) {

                    Button {

                        showAddCategory = true

                    } label: {

                        Image(
                            systemName: "plus"
                        )
                    }
                    .accessibilityLabel(
                        "Add category"
                    )
                }
            }
            .sheet(
                isPresented: $showAddCategory
            ) {

                CategoryEditorView(
                    title: String(
                        localized: "category_editor.new_category"
                    )
                ) { name, budgetInCents in

                    viewModel.addCategory(
                        name: name,
                        budgetInCents: budgetInCents
                    )
                }
            }
            .sheet(
                item: $categoryToEdit
            ) { category in

                CategoryEditorView(
                    title: String(
                        localized: "category_editor.edit_category"
                    ),
                    initialName: category.name,
                    initialBudgetInCents: category.budgetInCents
                ) { name, budgetInCents in

                    viewModel.updateCategory(
                        category,
                        name: name,
                        budgetInCents: budgetInCents
                    )
                }
            }
        }
    }
}

#Preview {

    CategoriesView()
        .modelContainer(
            PersistenceController.preview
        )
}
