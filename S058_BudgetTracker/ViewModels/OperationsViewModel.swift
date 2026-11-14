import Foundation
import Combine
import SwiftData
import FirebaseAnalytics

@MainActor
final class OperationsViewModel: ObservableObject {

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func addOperation(
        date: Date,
        description: String,
        amountInCents: Int,
        category: String
    ) {
        let operation = Operation(
            date: date,
            operationDescription: description,
            amountInCents: amountInCents,
            category: category
        )

        modelContext.insert(operation)
        save()
        Analytics.logEvent("operation_added", parameters: nil)
    }

    func updateOperation(
        _ operation: Operation,
        date: Date,
        description: String,
        amountInCents: Int,
        category: String
    ) {
        operation.date = date
        operation.operationDescription = description
        operation.amountInCents = amountInCents
        operation.category = category

        save()
    }

    func deleteOperations(
        _ operations: [Operation]
    ) {

        for operation in operations {
            modelContext.delete(operation)
        }

        save()
        Analytics.logEvent("operation_deleted", parameters: [
                "count": operations.count
            ])
    }
    
    func deleteOperation(
        _ operation: Operation
    ) {
        modelContext.delete(operation)

        save()
        Analytics.logEvent("operation_deleted", parameters: [
                "count": 1
            ])
    }

    private func save() {
        do {
            try modelContext.save()
        } catch {
            print(
                "Failed to save operation: \(error)"
            )
        }
    }
}
