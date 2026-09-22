//
//  CategoriesViewModel.swift
//  S058_BudgetTracker
//
//  Created by Olivier Marteaux on 20/09/2026.
//


import Foundation
import SwiftData
import Combine

@MainActor
final class CategoriesViewModel: ObservableObject {

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func addCategory(
        name: String,
        budgetInCents: Int?
    ) {
        let trimmedName = name.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !trimmedName.isEmpty else {
            return
        }

        guard !categoryExists(
            named: trimmedName
        ) else {
            return
        }

        let category = Category(
            name: trimmedName,
            budgetInCents: budgetInCents
        )

        modelContext.insert(category)
        save()
    }

    func updateCategory(
        _ category: Category,
        name: String,
        budgetInCents: Int?
    ) {
        let trimmedName = name.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !trimmedName.isEmpty else {
            return
        }

        let oldName = category.name

        guard oldName == trimmedName ||
                !categoryExists(
                    named: trimmedName,
                    excluding: category
                )
        else {
            return
        }

        let descriptor = FetchDescriptor<Operation>(
            predicate: #Predicate {
                $0.category == oldName
            }
        )

        do {
            let operations =
                try modelContext.fetch(descriptor)

            for operation in operations {
                operation.category = trimmedName
            }

            category.name = trimmedName
            category.budgetInCents = budgetInCents

            save()

        } catch {
            print(
                "Failed to update category: \(error)"
            )
        }
    }

    func deleteCategory(
        _ category: Category
    ) {

        let categoryName = category.name

        // Clear the category on all concerned
        // operations before deleting it.
        let descriptor = FetchDescriptor<Operation>(
            predicate: #Predicate {
                $0.category == categoryName
            }
        )

        do {

            let operations =
                try modelContext.fetch(descriptor)

            for operation in operations {
                operation.category = ""
            }

            modelContext.delete(category)

            save()

        } catch {

            print(
                "Failed to delete category: \(error)"
            )
        }
    }

    private func categoryExists(
        named name: String,
        excluding categoryToExclude: Category? = nil
    ) -> Bool {

        let descriptor = FetchDescriptor<Category>(
            predicate: #Predicate {
                $0.name == name
            }
        )

        do {

            let categories =
                try modelContext.fetch(descriptor)

            if let categoryToExclude {
                return categories.contains {
                    $0.id != categoryToExclude.id
                }
            }

            return !categories.isEmpty

        } catch {

            print(
                "Failed to check category: \(error)"
            )

            return true
        }
    }

    private func save() {

        do {
            try modelContext.save()
        } catch {
            print(
                "Failed to save category: \(error)"
            )
        }
    }
}
