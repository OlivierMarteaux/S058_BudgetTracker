@Observable
final class CurrencyStore {
    private let key = "currencySymbol"

    var symbol: String {
        didSet {
            UserDefaults.standard.set(symbol, forKey: key)
        }
    }

    init() {
        symbol = UserDefaults.standard.string(forKey: key) ?? "€"
    }
}