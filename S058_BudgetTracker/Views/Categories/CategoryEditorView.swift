//
//  CategoryEditorView.swift
//  S058_BudgetTracker
//
//  Created by Olivier Marteaux on 20/09/2026.
//


import SwiftUI

struct CategoryEditorView: View {

    let title: String
    let initialName: String
    let onSave: (String) -> Void

    @Environment(\.dismiss)
    private var dismiss

    @State private var name: String

    init(
        title: String,
        initialName: String = "",
        onSave: @escaping (String) -> Void
    ) {

        self.title = title
        self.initialName = initialName
        self.onSave = onSave

        _name = State(
            initialValue: initialName
        )
    }

    var body: some View {

        NavigationStack {

            Form {

                TextField(
                    "Category name",
                    text: $name
                )
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

                        onSave(trimmedName)
                        dismiss()
                    }
                }
            }
        }
    }
}