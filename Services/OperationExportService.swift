//
//  OperationExportService.swift
//  S058_BudgetTracker
//
//  Created by Olivier Marteaux on 19/09/2026.
//


import Foundation

struct OperationExportService {

    static func csvData(
        from operations: [Operation]
    ) -> Data {

        var rows: [String] = []

        // CSV header
        rows.append(
            "Date,Description,Category,Amount"
        )

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        for operation in operations {

            let date = formatter.string(
                from: operation.date
            )

            let description = escapeCSVField(
                operation.operationDescription
            )

            let category = escapeCSVField(
                operation.category
            )

            let amount = String(
                format: "%.2f",
                Double(operation.amountInCents) / 100
            )

            rows.append(
                "\(date),\(description),\(category),\(amount)"
            )
        }

        let csv = rows.joined(
            separator: "\n"
        )

        // UTF-8 with BOM so Excel/Numbers correctly
        // recognize accented French characters.
        let bom = "\u{FEFF}"

        return Data(
            (bom + csv).utf8
        )
    }

    private static func escapeCSVField(
        _ value: String
    ) -> String {

        let escaped = value.replacingOccurrences(
            of: "\"",
            with: "\"\""
        )

        if escaped.contains(",")
            || escaped.contains("\"")
            || escaped.contains("\n")
            || escaped.contains("\r") {

            return "\"\(escaped)\""
        }

        return escaped
    }
}