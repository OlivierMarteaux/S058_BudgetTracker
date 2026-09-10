import Foundation
import SwiftData

enum PersistenceController {

    static let appGroupIdentifier =
        "group.com.oliviermarteaux.BudgetTracker"

    static let shared: ModelContainer = {

        do {
            let schema = Schema([
                Operation.self,
                Category.self
            ])

            guard let containerURL =
                    FileManager.default.containerURL(
                        forSecurityApplicationGroupIdentifier:
                            appGroupIdentifier
                    )
            else {
                fatalError(
                    "Could not access App Group container."
                )
            }

            let storeURL =
                containerURL.appendingPathComponent(
                    "BudgetTracker.sqlite"
                )

            let configuration = ModelConfiguration(
                schema: schema,
                url: storeURL,
                cloudKitDatabase: .none
            )

            return try ModelContainer(
                for: schema,
                configurations: [configuration]
            )

        } catch {
            fatalError(
                "Could not create ModelContainer: \(error)"
            )
        }
    }()

    static var preview: ModelContainer = {

        do {
            let configuration = ModelConfiguration(
                isStoredInMemoryOnly: true
            )

            let container = try ModelContainer(
                for: Operation.self,
                Category.self,
                configurations: configuration
            )

            let context = container.mainContext

            context.insert(
                Operation(
                    date: Date(),
                    operationDescription: "Salary",
                    amountInCents: 250_000
                )
            )

            context.insert(
                Operation(
                    date: Calendar.current.date(
                        byAdding: .day,
                        value: -1,
                        to: Date()
                    ) ?? Date(),
                    operationDescription: "Groceries",
                    amountInCents: -5_450
                )
            )

            context.insert(
                Operation(
                    date: Calendar.current.date(
                        byAdding: .day,
                        value: -3,
                        to: Date()
                    ) ?? Date(),
                    operationDescription: "Gas",
                    amountInCents: -6_200
                )
            )

            return container

        } catch {
            fatalError(
                "Could not create preview container: \(error)"
            )
        }
    }()
}
