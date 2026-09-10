//
//  OperationEditorView.swift
//  S058_BudgetTracker
//
//  Created by Olivier Marteaux on 10/09/2026.
//

import SwiftUI

struct OperationEditorView: View {

    @Environment(\.dismiss)
    private var dismiss

    @State private var date: Date
    @State private var description: String
    @State private var amount: String

    let operation: Operation?
    let onSave: (
        Date,
        String,
        Int
    ) -> Void

    init(
        operation: Operation? = nil,
        onSave: @escaping (
            Date,
            String,
            Int
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
    }

    private var isEditing: Bool {
        operation != nil
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

                    TextField(
                        "Amount (€)",
                        text: $amount
                    )
                    .keyboardType(
                        .decimalPad
                    )
                }

                Section {

                    Text(
                        "Positive amount = income\nNegative amount = expense"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }
            .navigationTitle(
                isEditing
                    ? "Edit operation"
                    : "New operation"
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
                            cents
                        )

                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }
}
