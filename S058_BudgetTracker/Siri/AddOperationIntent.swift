
import AppIntents
import SwiftData

struct AddOperationIntent: AppIntent {

    static var title: LocalizedStringResource = "Enregistrer une opération dans Budget Tracker."

    static var description = IntentDescription(
        "Enregistre une opération dans Budget Tracker."
    )

    @Parameter(
        title: "Montant",
        description: "Montant de la dépense"
    )
    var amount: String

    @Parameter(
        title: "Description",
        description: "Description de la dépense"
    )
    var operationDescription: String

    @Parameter(
        title: "Catégorie",
        description: "Catégorie de la dépense"
    )
    var category: CategoryEntity

    func perform() async throws -> some IntentResult & ProvidesDialog {
        
        let normalizedAmount = amount
            .lowercased()
            .replacingOccurrences(of: "euros", with: "")
            .replacingOccurrences(of: "euro", with: "")
            .replacingOccurrences(of: "€", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ",", with: ".")
        
        guard let amountValue = Double(normalizedAmount) else {
            return .result(
                dialog: "Je n'ai pas compris le montant \(amount)."
            )
        }
                
        let amountInCents = Int(
            (amountValue * 100).rounded()
        )
        
        let context = ModelContext(
            PersistenceController.shared
        )
        
        let operation = Operation(
            date: Date(),
            operationDescription: operationDescription,
            amountInCents: amountInCents,
            category: category.name
        )
        
        context.insert(operation)
        
        try context.save()
                
        return .result(
            dialog: "OK, j'ai ajouté une dépense de \(amount), \(operationDescription), pour \(category.name)."
        )
    }
}
