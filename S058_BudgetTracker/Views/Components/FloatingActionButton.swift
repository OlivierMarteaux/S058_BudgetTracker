//
//  FloatingActionButton.swift
//  S058_BudgetTracker
//
//  Created by Olivier Marteaux on 10/09/2026.
//

import SwiftUI

struct FloatingActionButton: View {

    let action: () -> Void

    var body: some View {

        Button(action: action) {

            Image(systemName: "plus")
                .font(.title2.weight(.bold))
                .foregroundStyle(.white)
                .frame(
                    width: 58,
                    height: 58
                )
                .background(
                    AppTheme.primaryBlue
                )
                .clipShape(Circle())
                .shadow(
                    radius: 6,
                    y: 3
                )
        }
        .accessibilityLabel(
            "Add operation"
        )
    }
}
