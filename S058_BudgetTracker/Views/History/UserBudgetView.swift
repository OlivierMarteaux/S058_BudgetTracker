//
//  UserBudgetView.swift
//  S058_BudgetTracker
//
//  Created by Olivier Marteaux on 20/09/2026.
//


import SwiftUI

struct UserBudgetView: View {

    @Environment(\.dismiss)
    private var dismiss

    @ObservedObject var budgetStore: UserBudgetStore

    @State private var budget: String

    init(
        budgetStore: UserBudgetStore
    ) {

        self.budgetStore = budgetStore

        _budget = State(
            initialValue:
                budgetStore.budgetInCents.map {
                    String(
                        format: "%.2f",
                        Double($0) / 100
                    )
                } ?? ""
        )
    }

    private var budgetInCents: Int? {

        let normalized = budget
            .replacingOccurrences(
                of: ",",
                with: "."
            )

        guard let value = Double(
            normalized
        ) else {
            return nil
        }

        return Int(
            (value * 100).rounded()
        )
    }

    var body: some View {

        NavigationStack {

            Form {

                Section("Monthly budget") {

                    TextField(
                        "Budget (€)",
                        text: $budget
                    )
                    .keyboardType(
                        .decimalPad
                    )

                    Text(
                        "This limit will appear as a red line on the historical chart."
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }

                if budgetStore.budgetInCents != nil {

                    Section {

                        Button(
                            role: .destructive
                        ) {
                            budgetStore.clearBudget()
                            dismiss()
                        } label: {
                            Text("Remove budget")
                        }
                    }
                }
            }
            .navigationTitle("User Budget")
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

                        guard let cents =
                            budgetInCents,
                            cents >= 0
                        else {
                            return
                        }

                        budgetStore.setBudget(
                            amountInCents: cents
                        )

                        dismiss()
                    }
                    .disabled(
                        budgetInCents == nil
                        || budgetInCents! < 0
                    )
                }
            }
        }
    }
}