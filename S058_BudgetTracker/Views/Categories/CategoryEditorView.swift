import SwiftUI

struct CategoryEditorView: View {

    let title: String
    let initialName: String
    let initialBudgetInCents: Int?
    let onSave: (String, Int?) -> Void

    @Environment(\.dismiss)
    private var dismiss

    @State private var name: String
    @State private var budget: String

    init(
        title: String,
        initialName: String = "",
        initialBudgetInCents: Int? = nil,
        onSave: @escaping (String, Int?) -> Void
    ) {
        self.title = title
        self.initialName = initialName
        self.initialBudgetInCents = initialBudgetInCents
        self.onSave = onSave

        _name = State(
            initialValue: initialName
        )

        _budget = State(
            initialValue:
                initialBudgetInCents.map {
                    String($0 / 100)
                } ?? ""
        )
    }

    var body: some View {

        NavigationStack {

            Form {

                TextField(
                    "Category name",
                    text: $name
                )

                TextField(
                    "Monthly budget",
                    text: $budget
                )
                .keyboardType(.numberPad)
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
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

                        let trimmedName =
                            name.trimmingCharacters(
                                in: .whitespacesAndNewlines
                            )

                        guard !trimmedName.isEmpty else {
                            return
                        }

                        let trimmedBudget =
                            budget.trimmingCharacters(
                                in: .whitespacesAndNewlines
                            )

                        let budgetInCents: Int?

                        if trimmedBudget.isEmpty {
                            budgetInCents = nil
                        } else if let value =
                                    Int(trimmedBudget),
                                  value >= 0 {

                            budgetInCents = value * 100

                        } else {
                            return
                        }

                        onSave(
                            trimmedName,
                            budgetInCents
                        )

                        dismiss()
                    }
                }
            }
        }
    }
}
