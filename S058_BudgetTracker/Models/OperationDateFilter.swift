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
            return String(
                localized: "operation_date_filter.all"
            )

        case .thisMonth:
            return String(
                localized: "operation_date_filter.this_month"
            )

        case .lastMonth:
            return String(
                localized: "operation_date_filter.last_month"
            )

        case .custom:
            return String(
                localized: "operation_date_filter.custom"
            )
        }
    }
}
