//
//  EmptyStateView.swift
//  S058_BudgetTracker
//
//  Created by Olivier Marteaux on 10/09/2026.
//

import SwiftUI

struct EmptyStateView: View {

    let title: String
    let message: String

    var body: some View {

        ContentUnavailableView {
            Label(
                title,
                systemImage: "eurosign.circle"
            )
        } description: {
            Text(message)
        }
    }
}
