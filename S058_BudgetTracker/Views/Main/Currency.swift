import Foundation

enum Currency: String, CaseIterable, Identifiable {
    case eur = "EUR"
    case usd = "USD"

    var id: String {
        rawValue
    }

    var symbol: String {
        switch self {
        case .eur:
            return "€"
        case .usd:
            return "$"
        }
    }

    var displayName: String {
        switch self {
        case .eur:
            return "Euro (€)"
        case .usd:
            return "US Dollar ($)"
        }
    }
}
