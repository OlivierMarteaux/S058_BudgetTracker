
import AppIntents
import SwiftData
import OSLog

nonisolated let logger = Logger(
    subsystem: "com.oliviermarteaux.BudgetTracker",
    category: "OM_TAG"
)

struct AddOperationIntent: AppIntent {

    static var title: LocalizedStringResource = "Add an expense to Budget Tracker."

    static var description = IntentDescription(
        "Add a new expense to Budget Tracker."
    )

    @Parameter(
        title: "Amount",
        description: "Expense amount"
    )
    var amount: String

    @Parameter(
        title: "Description",
        description: "expense description"
    )
    var operationDescription: String

    @Parameter(
        title: "Category",
        description: "Expense category"
    )
    var category: String

    private func parseAmount(_ text: String) -> Double? {
        let normalized = text
            .lowercased()
            .replacingOccurrences(of: "€", with: "")
            .replacingOccurrences(of: "euros", with: "")
            .replacingOccurrences(of: "euro", with: "")
//            .replacingOccurrences(of: "centimes", with: "")
//            .replacingOccurrences(of: "centime", with: "")
//            .replacingOccurrences(of: "et", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        logger.debug("normalized = \(normalized)")

        // Numeric amount: "2,50" / "2.50" / "2"
        let numeric = normalized
            .replacingOccurrences(of: ",", with: ".")
        
        logger.debug("numeric = \(numeric)")


        if let value = Double(numeric) {
            return value
        }

        // French number words
        let numberWords: [String: Double] = [
            "zéro": 0,
            "un": 1,
            "une": 1,
            "deux": 2,
            "trois": 3,
            "quatre": 4,
            "cinq": 5,
            "six": 6,
            "sept": 7,
            "huit": 8,
            "neuf": 9,
            "dix": 10,
            "onze": 11,
            "douze": 12,
            "treize": 13,
            "quatorze": 14,
            "quinze": 15,
            "seize": 16,
            "vingt": 20,
            "trente": 30,
            "quarante": 40,
            "cinquante": 50,
            "soixante": 60,
            
            // English
            "zero": 0,
            "one": 1,
            "a": 1,
            "two": 2,
            "three": 3,
            "four": 4,
            "five": 5,
            "seven": 7,
            "eight": 8,
            "nine": 9,
            "ten": 10,
            "eleven": 11,
            "twelve": 12,
            "thirteen": 13,
            "fourteen": 14,
            "fifteen": 15,
            "sixteen": 16,
            "twenty": 20,
            "thirty": 30,
            "forty": 40,
            "fifty": 50,
            "sixty": 60
        ]

        let words = normalized
            .split(separator: " ")
            .map(String.init)

        if words.count == 1,
           let value = numberWords[words[0]] {
            return value
        }

        return nil
    }

    func perform() async throws -> some IntentResult & ProvidesDialog {
        
//        let normalizedAmount = amount
//            .lowercased()
//            .replacingOccurrences(of: "euros", with: "")
//            .replacingOccurrences(of: "euro", with: "")
//            .replacingOccurrences(of: "€", with: "")
//            .trimmingCharacters(in: .whitespacesAndNewlines)
//            .replacingOccurrences(of: " ", with: "")
//            .replacingOccurrences(of: ",", with: ".")
        
        logger.debug("amount = \(amount).")
//        logger.debug("normalizedAmount = \(normalizedAmount).")
        
//        guard let amountValue = Double(normalizedAmount) else {
//            return .result(
//                dialog: "Je n'ai pas compris le montant \(amount)."
//            )
//        }
        
        guard let amountValue = parseAmount(amount) else {
            return .result(
                dialog: "I have not understood the amount \(amount)."
            )
        }
                
        let amountInCents = Int(
            (amountValue * 100).rounded()
        )

        let context = ModelContext(
            PersistenceController.shared
        )

        let descriptor = FetchDescriptor<Category>()

        let categories = try context.fetch(descriptor)

        guard let selectedCategory = categories.first(
            where: {
                $0.name.localizedCaseInsensitiveContains(category)
                    || category.localizedCaseInsensitiveContains($0.name)
            }
        ) else {
            return .result(
                dialog: "I have not understood the category \(category)."
            )
        }
        
        let operation = Operation(
            date: Date(),
            operationDescription: operationDescription,
            amountInCents: amountInCents,
            category: selectedCategory.name
        )
        
        context.insert(operation)
        
        try context.save()
                
        return .result(
            dialog: "OK, I added an expense \(amount), \(operationDescription), for \(selectedCategory.name)."
        )
    }
}
