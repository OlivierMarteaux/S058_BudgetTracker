import Foundation
import SwiftData

@Model
final class Category {

    var id: UUID

    var name: String

    var budgetInCents: Int?

    init(
        id: UUID = UUID(),
        name: String,
        budgetInCents: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.budgetInCents = budgetInCents
    }
}
