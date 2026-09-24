//
//  CategoryEntity.swift
//  S058_BudgetTracker
//
//  Created by Olivier Marteaux on 24/09/2026.
//

import AppIntents
import SwiftData

struct CategoryEntity: AppEntity {

    static var typeDisplayRepresentation = TypeDisplayRepresentation(
        name: "Catégorie"
    )

    static var defaultQuery = CategoryEntityQuery()

    var id: UUID
    var name: String

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(name)"
        )
    }

    init(category: Category) {
        self.id = category.id
        self.name = category.name
    }

    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}
