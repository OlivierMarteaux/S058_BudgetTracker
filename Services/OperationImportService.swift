import Foundation

struct OperationImportService {

    enum DateFormat: String, CaseIterable, Identifiable {
        case yyyyMMdd = "yyyy/MM/dd"
        case yyyyddMM = "yyyy/dd/MM"
        case yyMMdd = "yy/MM/dd"
        case yyddMM = "yy/dd/MM"
        case ddMMyyyy = "dd/MM/yyyy"
        case MMddyyyy = "MM/dd/yyyy"
        case ddMMyy = "dd/MM/yy"
        case MMddyy = "MM/dd/yy"

        var id: String { rawValue }
    }

    enum AmountFormat: String, CaseIterable, Identifiable {
        case integer = "Integer"
        case commaDecimal = "Comma decimal (,)"
        case dotDecimal = "Dot decimal (.)"

        var id: String { rawValue }
    }

    static func importOperations(
        from data: Data,
        dateFormat: DateFormat,
        amountFormat: AmountFormat
    ) -> [ImportedOperation] {

        guard var content = String(
            data: data,
            encoding: .utf8
        ) else {
            return []
        }

        // Remove UTF-8 BOM if present.
        content = content.replacingOccurrences(
            of: "\u{FEFF}",
            with: ""
        )

        let lines = content
            .components(separatedBy: .newlines)
            .filter {
                !$0.trimmingCharacters(
                    in: .whitespacesAndNewlines
                ).isEmpty
            }

        guard lines.count > 1 else {
            return []
        }

        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat.rawValue
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)

        return lines.dropFirst().compactMap { line in

            let fields = parseCSVLine(line)

            guard fields.count >= 4 else {
                return nil
            }

            guard let date = formatter.date(
                from: fields[0].trimmingCharacters(
                    in: .whitespaces
                )
            ) else {
                return nil
            }

            let amountString = fields[3]
                .trimmingCharacters(
                    in: .whitespaces
                )

            let normalizedAmount: String

            switch amountFormat {
            case .integer:
                normalizedAmount = amountString

            case .commaDecimal:
                normalizedAmount = amountString
                    .replacingOccurrences(
                        of: ",",
                        with: "."
                    )

            case .dotDecimal:
                normalizedAmount = amountString
            }

            guard let amount = Double(normalizedAmount)
            else {
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
                       line.index(after: index)
                   ] == "\"" {

                    current.append("\"")

                    index = line.index(after: index)

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

            index = line.index(after: index)
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
