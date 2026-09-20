//
//  OperationImportService.swift
//  S058_BudgetTracker
//
//  Created by Olivier Marteaux on 20/09/2026.
//


import Foundation

struct OperationImportService {

    static func importOperations(
        from data: Data
    ) -> [ImportedOperation] {

        guard var content = String(
            data: data,
            encoding: .utf8
        ) else {
            return []
        }

        // Remove UTF-8 BOM if present
        content = content.replacingOccurrences(
            of: "\u{FEFF}",
            with: ""
        )

        // Normalize Windows / Mac / Unix line endings
        content = content
            .replacingOccurrences(
                of: "\r\n",
                with: "\n"
            )
            .replacingOccurrences(
                of: "\r",
                with: "\n"
            )

        let lines = content
            .components(separatedBy: "\n")
            .filter {
                !$0.trimmingCharacters(
                    in: .whitespaces
                ).isEmpty
            }

        guard lines.count > 1 else {
            return []
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        return lines.dropFirst().compactMap { line in

            let fields = parseCSVLine(line)

            guard fields.count >= 4 else {
                return nil
            }

            guard let date = formatter.date(
                from: fields[0]
            ) else {
                return nil
            }

            let normalizedAmount = fields[3]
                .replacingOccurrences(
                    of: ",",
                    with: "."
                )

            guard let amount = Double(
                normalizedAmount
            ) else {
                return nil
            }

            let amountInCents = Int(
                (amount * 100).rounded()
            )

            return ImportedOperation(
                date: date,
                description: fields[1],
                category: fields[2],
                amountInCents: amountInCents
            )
        }
    }

    private static func parseCSVLine(
        _ line: String
    ) -> [String] {

        var fields: [String] = []
        var current = ""
        var insideQuotes = false

        var index = line.startIndex

        while index < line.endIndex {

            let character = line[index]

            if character == "\"" {

                if insideQuotes,
                   index < line.index(
                       before: line.endIndex
                   ),
                   line[
                       line.index(
                           after: index
                       )
                   ] == "\"" {

                    current.append("\"")

                    index = line.index(
                        after: index
                    )

                } else {
                    insideQuotes.toggle()
                }

            } else if character == ","
                        && !insideQuotes {

                fields.append(current)
                current = ""

            } else {
                current.append(character)
            }

            index = line.index(
                after: index
            )
        }

        fields.append(current)

        return fields
    }
}

struct ImportedOperation {

    let date: Date
    let description: String
    let category: String
    let amountInCents: Int
}
