import Foundation
import SwiftData

@MainActor
final class CategoryStore {

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func categories() -> [Category] {

        let descriptor = FetchDescriptor<Category>(
            sortBy: [
                SortDescriptor(
                    \.name,
                    order: .forward
                )
            ]
        )

        do {
            return try modelContext.fetch(
                descriptor
            )
        } catch {
            print(
                "Failed to fetch categories: \(error)"
            )
            return []
        }
    }

    func addCategory(
        name: String
    ) {

        let trimmedName = name
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        guard !trimmedName.isEmpty else {
            return
        }

        // Prevent duplicate category names.
        let existing = categories()

        guard !existing.contains(
            where: {
                $0.name.caseInsensitiveCompare(
                    trimmedName
                ) == .orderedSame
            }
        ) else {
            return
        }

        modelContext.insert(
            Category(name: trimmedName)
        )

        save()
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
