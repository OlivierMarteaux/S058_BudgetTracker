//
//  ImportOperationsView.swift
//  S058_BudgetTracker
//
//  Created by Olivier Marteaux on 20/09/2026.
//


import SwiftUI
import SwiftData
import UniformTypeIdentifiers

private func ensureCategoryExists(
    named name: String,
    in modelContext: ModelContext
) throws {

    let trimmedName = name.trimmingCharacters(
        in: .whitespacesAndNewlines
    )

    guard !trimmedName.isEmpty else {
        return
    }

    let descriptor = FetchDescriptor<Category>(
        predicate: #Predicate {
            $0.name == trimmedName
        }
    )

    let existingCategories =
        try modelContext.fetch(descriptor)

    guard existingCategories.isEmpty else {
        return
    }

    modelContext.insert(
        Category(
            name: trimmedName
        )
    )
}

struct ImportOperationsView: View {

    @Environment(\.dismiss)
    private var dismiss

    @Environment(\.modelContext)
    private var modelContext

    @State private var showImporter = false

    var body: some View {

        NavigationStack {

            Form {

                Section("Import operations") {

                    Text(
                        "Select a CSV file exported from BudgetTracker."
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                    Button {
                        showImporter = true
                    } label: {
                        HStack {

                            Spacer()

                            Label(
                                "Choose CSV file",
                                systemImage:
                                    "doc.badge.plus"
                            )

                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Import operations")
            .navigationBarTitleDisplayMode(.inline)
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
        .fileImporter(
            isPresented: $showImporter,
            allowedContentTypes: [
                .commaSeparatedText
            ]
        ) { result in

            switch result {

            case .success(let url):

                importCSV(
                    from: url
                )

            case .failure(let error):

                print(
                    "CSV import failed: \(error)"
                )
            }
        }
    }

    private func importCSV(
        from url: URL
    ) {

        guard url.startAccessingSecurityScopedResource()
        else {
            print(
                "Could not access selected file."
            )
            return
        }

        defer {
            url.stopAccessingSecurityScopedResource()
        }

        do {

            let data = try Data(
                contentsOf: url
            )

            let imported =
                OperationImportService
                    .importOperations(
                        from: data
                    )

            for item in imported {
                
                try ensureCategoryExists(
                    named: item.category,
                    in: modelContext
                )

                let operation = Operation(
                    date: item.date,
                    operationDescription:
                        item.description,
                    amountInCents:
                        item.amountInCents,
                    category:
                        item.category
                )

                modelContext.insert(
                    operation
                )
            }

            try modelContext.save()

            dismiss()

        } catch {

            print(
                "Failed to import CSV: \(error)"
            )
        }
    }
}

