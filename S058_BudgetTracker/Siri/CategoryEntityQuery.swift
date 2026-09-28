//
//import AppIntents
//import SwiftData
//
//struct CategoryEntityQuery: EntityStringQuery {
//
//    func entities(
//        matching string: String
//    ) async throws -> [CategoryEntity] {
//
//        let context = ModelContext(
//            PersistenceController.shared
//        )
//
//        let descriptor = FetchDescriptor<Category>()
//
//        let categories = try context.fetch(descriptor)
//
//        return categories
//            .filter {
//                $0.name.localizedCaseInsensitiveContains(string)
//            }
//            .map {
//                CategoryEntity(category: $0)
//            }
//    }
//
//    func entities(
//        for identifiers: [CategoryEntity.ID]
//    ) async throws -> [CategoryEntity] {
//
//        let context = ModelContext(
//            PersistenceController.shared
//        )
//
//        let descriptor = FetchDescriptor<Category>()
//
//        let categories = try context.fetch(descriptor)
//
//        return categories
//            .filter {
//                identifiers.contains($0.id)
//            }
//            .map {
//                CategoryEntity(category: $0)
//            }
//    }
//
//    func suggestedEntities() async throws -> [CategoryEntity] {
//
//        let context = ModelContext(
//            PersistenceController.shared
//        )
//
//        let descriptor = FetchDescriptor<Category>()
//
//        let categories = try context.fetch(descriptor)
//
//        return categories.map {
//            CategoryEntity(category: $0)
//        }
//    }
//}
