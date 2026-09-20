import Foundation

enum OperationDateFilter: Equatable {
    case all
    case thisMonth
    case lastMonth
    case custom(
        from: Date,
        to: Date
    )
}

enum OperationDateFilterOption: String, CaseIterable, Identifiable {

    case all
    case thisMonth
    case lastMonth
    case custom

    var id: String {
        rawValue
    }

    var title: String {

        switch self {

        case .all:
            return "All Dates"

        case .thisMonth:
            return "This Month"

        case .lastMonth:
            return "Last Month"

        case .custom:
            return "Custom Range"
        }
    }
}
