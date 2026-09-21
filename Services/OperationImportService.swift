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
        case yyyyMMddDash = "yyyy-MM-dd"
        case yyyyddMMDash = "yyyy-dd-MM"
        case yyMMddDash = "yy-MM-dd"
        case yyddMMDash = "yy-dd-MM"
        case ddMMyyyyDash = "dd-MM-yyyy"
        case MMddyyyyDash = "MM-dd-yyyy"
        case ddMMyyDash = "dd-MM-yy"
        case MMddyyDash = "MM-dd-yy"

        var id: String {
            rawValue
        }
        
        var title: String {
            switch self {

            case .yyyyMMdd:
                return String(
                    localized: "date_format.yyyyMMdd"
                )

            case .yyyyddMM:
                return String(
                    localized: "date_format.yyyyddMM"
                )

            case .yyMMdd:
                return String(
                    localized: "date_format.yyMMdd"
                )
            case .yyddMM:
                return String(
                    localized: "date_format.yyddMM"
                )
            case .ddMMyyyy:
                return String(
                    localized: "date_format.ddMMyyyy"
                )
            case .MMddyyyy:
                return String(
                    localized: "date_format.MMddyyyy"
                )
            case .ddMMyy:
                return String(
                    localized: "date_format.ddMMyy"
                )
            case .MMddyy:
                return String(
                    localized: "date_format.MMddyy"
                )
            case .yyyyMMddDash:
                return String(
                    localized: "date_format.yyyyMMddDash"
                )
            case .yyyyddMMDash:
                return String(
                    localized: "date_format.yyyyddMMDash"
                )
            case .yyMMddDash:
                return String(
                    localized: "date_format.yyMMddDash"
                )
            case .yyddMMDash:
                return String(
                    localized: "date_format.yyddMMDash"
                )
            case .ddMMyyyyDash:
                return String(
                    localized: "date_format.ddMMyyyyDash"
                )
            case .MMddyyyyDash:
                return String(
                    localized: "date_format.MMddyyyyDash"
                )
            case .ddMMyyDash:
                return String(
                    localized: "date_format.ddMMyyDash"
                )
            case .MMddyyDash:
                return String(
                    localized: "date_format.MMddyyDash"
                )
            }
        }
    }

    enum AmountFormat: String, CaseIterable, Identifiable {

        case integer
        case commaDecimal
        case dotDecimal

        var id: String {
            rawValue
        }

        var title: String {
            switch self {

            case .integer:
                return String(
                    localized: "amount_format.integer"
                )

            case .commaDecimal:
                return String(
                    localized: "amount_format.comma_decimal"
                )

            case .dotDecimal:
                return String(
                    localized: "amount_format.dot_decimal"
                )
            }
        }
    }

    static func importOperations(
        from data: Data,
        dateFormat: DateFormat,
        amountFormat: AmountFormat
    ) -> [ImportedOperation] {

        guard var content = decode(data) else {
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

        let separator = detectSeparator(
            from: lines[0]
        )

        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat.rawValue
        formatter.locale = Locale(
            identifier: "en_US_POSIX"
        )
        formatter.calendar = Calendar(
            identifier: .gregorian
        )

        return lines.dropFirst().compactMap { line in

            let fields = parseCSVLine(
                line,
                separator: separator
            )

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

    // MARK: - Encoding detection

    private static func decode(
        _ data: Data
    ) -> String? {

        // UTF-8 BOM
        if data.starts(
            with: [0xEF, 0xBB, 0xBF]
        ) {
            return String(
                data: data,
                encoding: .utf8
            )
        }

        // UTF-8
        if let content = String(
            data: data,
            encoding: .utf8
        ) {
            return content
        }

        // ANSI / Windows-1252
        return String(
            data: data,
            encoding: .windowsCP1252
        )
    }

    // MARK: - Separator detection

    private static func detectSeparator(
        from header: String
    ) -> Character {

        let candidates: [Character] = [
            ",",
            ";",
            "\t"
        ]

        var bestSeparator: Character = ","
        var highestCount = 0

        for separator in candidates {

            let count = header.filter {
                $0 == separator
            }.count

            if count > highestCount {
                highestCount = count
                bestSeparator = separator
            }
        }

        return bestSeparator
    }

    // MARK: - CSV parsing

    private static func parseCSVLine(
        _ line: String,
        separator: Character
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

                    index = line.index(
                        after: index
                    )

                } else {
                    insideQuotes.toggle()
                }

            } else if character == separator
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
