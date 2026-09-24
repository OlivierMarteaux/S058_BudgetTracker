import SwiftUI
import SwiftData

struct OperationEditorView: View {

    @Environment(\.dismiss)
    private var dismiss

    @Environment(\.modelContext)
    private var modelContext

    @State private var date: Date
    @State private var description: String
    @State private var amount: String
    @State private var category: String

    @State private var showNewCategory = false
    @State private var newCategoryName = ""

    let operation: Operation?
    let onSave: (
        Date,
        String,
        Int,
        String
    ) -> Void

    init(
        operation: Operation? = nil,
        onSave: @escaping (
            Date,
            String,
            Int,
            String
        ) -> Void
    ) {

        self.operation = operation
        self.onSave = onSave

        _date = State(
            initialValue:
                operation?.date ?? Date()
        )

        _description = State(
            initialValue:
                operation?.operationDescription ?? ""
        )

        _amount = State(
            initialValue:
                operation.map {
                    String(
                        format: "%.2f",
                        Double($0.amountInCents) / 100
                    )
                } ?? ""
        )

        _category = State(
            initialValue:
                operation?.category ?? ""
        )
    }

    private var isEditing: Bool {
        operation != nil
    }

    private var categoryStore: CategoryStore {
        CategoryStore(
            modelContext: modelContext
        )
    }

    private var categories: [Category] {
        categoryStore.categories()
    }

    private var amountInCents: Int? {

        let normalized = amount
            .replacingOccurrences(
                of: ",",
                with: "."
            )

        guard let value = Double(normalized)
        else {
            return nil
        }

        return Int(
            (value * 100).rounded()
        )
    }

    private var canSave: Bool {

        !description
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            .isEmpty
        && amountInCents != nil
    }

    var body: some View {

        NavigationStack {

            Form {

                Section("Operation") {

                    DatePicker(
                        "Date",
                        selection: $date,
                        displayedComponents: .date
                    )

                    TextField(
                        "Description",
                        text: $description
                    )

                    HStack {

                        Picker(
                            "Category",
                            selection: $category
                        ) {

                            Text("None")
                                .tag("")

                            ForEach(categories) { categoryItem in

                                Text(categoryItem.name)
                                    .tag(categoryItem.name)
                            }
                        }

                        Spacer()

                        Button {

                            newCategoryName = ""
                            showNewCategory = true

                        } label: {

                            Image(
                                systemName: "plus.circle.fill"
                            )
                            .font(.title3)
                        }
                        .buttonStyle(.borderless)
                        .accessibilityLabel("Add category")
                    }

                    TextField(
                        "Amount",
                        text: $amount
                    )
                    .keyboardType(
                        .decimalPad
                    )
                }

                Section {

                    Text(
                        "Positive amount = expense\nNegative amount = income"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }
            .navigationTitle(
                isEditing
                ? String(localized: "operation_editor.edit_operation")
                    : String(localized: "operation_editor.new_operation")
            )
            .navigationBarTitleDisplayMode(
                .inline
            )
            .toolbar {

                ToolbarItem(
                    placement: .cancellationAction
                ) {

                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(
                    placement: .confirmationAction
                ) {

                    Button("Save") {

                        guard let cents = amountInCents
                        else {
                            return
                        }

                        onSave(
                            date,
                            description,
                            cents,
                            category
                        )

                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
            .alert(
                "New category",
                isPresented: $showNewCategory
            ) {

                TextField(
                    "Category name",
                    text: $newCategoryName
                )

                Button("Cancel", role: .cancel) {
                    newCategoryName = ""
                }

                Button("Add") {

                    let name = newCategoryName
                        .trimmingCharacters(
                            in: .whitespacesAndNewlines
                        )

                    guard !name.isEmpty else {
                        return
                    }

                    categoryStore.addCategory(
                        name: name
                    )

                    category = name
                    newCategoryName = ""
                }

            } message: {

                Text(
                    "Enter the name of the new category."
                )
            }
        }
    }
}
