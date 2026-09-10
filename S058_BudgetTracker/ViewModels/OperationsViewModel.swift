//
//  OperationsViewModel.swift
//  S058_BudgetTracker
//
//  Created by Olivier Marteaux on 10/09/2026.
//

import Foundation
import SwiftData
import Combine

@MainActor
final class OperationsViewModel: ObservableObject {

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - CRUD

    func addOperation(
        date: Date,
        description: String,
        amountInCents: Int
    ) {
        let operation = Operation(
            date: date,
            operationDescription: description,
            amountInCents: amountInCents
        )

        modelContext.insert(operation)
        save()
    }

    func updateOperation(
        _ operation: Operation,
        date: Date,
        description: String,
        amountInCents: Int
    ) {
        operation.date = date
        operation.operationDescription = description
        operation.amountInCents = amountInCents

        save()
    }

    func deleteOperation(_ operation: Operation) {
        modelContext.delete(operation)
        save()
    }

    // MARK: - Persistence

    private func save() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save operation: \(error)")
        }
    }
}
