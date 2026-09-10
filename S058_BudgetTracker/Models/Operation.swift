import Foundation
import SwiftData

@Model
final class Operation {

    var id: UUID
    var date: Date
    var operationDescription: String
    var amountInCents: Int
    var category: String

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        operationDescription: String = "",
        amountInCents: Int = 0,
        category: String = ""
    ) {
        self.id = id
        self.date = date
        self.operationDescription = operationDescription
        self.amountInCents = amountInCents
        self.category = category
    }

    var amount: Decimal {
        Decimal(amountInCents) / 100
    }

    var isIncome: Bool {
        amountInCents >= 0
    }

    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        formatter.locale = Locale(identifier: "fr_FR")

        let value = NSDecimalNumber(decimal: amount)
        return formatter.string(from: value)
            ?? "\(amountInCents) €"
    }
}
