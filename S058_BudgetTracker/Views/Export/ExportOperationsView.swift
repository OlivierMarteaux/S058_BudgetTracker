import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct ExportOperationsView: View {

    @Environment(\.dismiss)
    private var dismiss

    @Environment(\.modelContext)
    private var modelContext

    enum ExportRange {
        case all
        case dateRange
    }

    @State private var exportRange: ExportRange = .all

    @State private var startDate: Date = Date()

    @State private var endDate: Date = Date()

    @State private var document: CSVDocument?

    @State private var showExporter = false

    private var operations: [Operation] {

        let descriptor = FetchDescriptor<Operation>(
            sortBy: [
                SortDescriptor(
                    \.date,
                    order: .forward
                )
            ]
        )

        do {
            return try modelContext.fetch(
                descriptor
            )
        } catch {
            print(
                "Failed to fetch operations: \(error)"
            )
            return []
        }
    }

    private var operationsToExport: [Operation] {

        guard exportRange == .dateRange
        else {
            return operations
        }

        let calendar = Calendar.current

        let start = calendar.startOfDay(
            for: startDate
        )

        let end = calendar.date(
            byAdding: .day,
            value: 1,
            to: calendar.startOfDay(
                for: endDate
            )
        ) ?? endDate

        return operations.filter { operation in

            operation.date >= start
                && operation.date < end
        }
    }

    private func exportCSV() {

        let data =
            OperationExportService.csvData(
                from: operationsToExport
            )

        document = CSVDocument(
            data: data
        )

        showExporter = true
    }

    var body: some View {

        NavigationStack {

            Form {

                Section("Operations to export") {

                    Picker(
                        "Range",
                        selection: $exportRange
                    ) {

                        Text("All operations")
                            .tag(ExportRange.all)

                        Text("Date range")
                            .tag(ExportRange.dateRange)
                    }
                    .pickerStyle(.inline)
                }

                if exportRange == .dateRange {

                    Section("Date range") {

                        DatePicker(
                            "From",
                            selection: $startDate,
                            displayedComponents: .date
                        )

                        DatePicker(
                            "To",
                            selection: $endDate,
                            displayedComponents: .date
                        )
                    }
                }

                Section {

                    Button {
                        exportCSV()

                    } label: {

                        HStack {

                            Spacer()

                            Label(
                                "Export CSV",
                                systemImage:
                                    "square.and.arrow.up"
                            )

                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle(
                "Export operations"
            )
            .navigationBarTitleDisplayMode(
                .inline
            )
            .toolbar {

                ToolbarItem(
                    placement: .cancellationAction
                ) {

                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .fileExporter(
            isPresented: $showExporter,
            document: document,
            contentType: .commaSeparatedText,
            defaultFilename:
                "BudgetTracker_Operations.csv"
        ) { result in

            switch result {

            case .success:
                print(
                    "CSV export successful."
                )

            case .failure(let error):
                print(
                    "CSV export failed: \(error)"
                )
            }
        }
    }
}

#Preview {
    ExportOperationsView()
        .modelContainer(
            PersistenceController.preview
        )
}
