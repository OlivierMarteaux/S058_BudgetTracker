//
//  CSVDocument.swift
//  S058_BudgetTracker
//
//  Created by Olivier Marteaux on 19/09/2026.
//


import SwiftUI
import UniformTypeIdentifiers

struct CSVDocument: FileDocument {

    static var readableContentTypes: [UTType] {
        [.commaSeparatedText]
    }

    let data: Data

    init(data: Data) {
        self.data = data
    }

    init(
        configuration: ReadConfiguration
    ) throws {
        data = configuration.file.regularFileContents
            ?? Data()
    }

    func fileWrapper(
        configuration: WriteConfiguration
    ) throws -> FileWrapper {

        FileWrapper(
            regularFileWithContents: data
        )
    }
}