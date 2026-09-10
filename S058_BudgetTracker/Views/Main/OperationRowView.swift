//
//  OperationRowView.swift
//  S058_BudgetTracker
//
//  Created by Olivier Marteaux on 10/09/2026.
//

import SwiftUI

struct OperationRowView: View {

    let operation: Operation

    private var amountColor: Color {
        operation.isIncome
            ? AppTheme.positive
            : AppTheme.negative
    }

    var body: some View {

        HStack(spacing: 12) {

            VStack(
                alignment: .leading,
                spacing: 5
            ) {

                Text(
                    operation.date,
                    format: .dateTime
                        .day()
                        .month(.abbreviated)
                        .year()
                )
                .font(.caption)
                .foregroundStyle(.secondary)

                Text(operation.operationDescription)
                    .font(.body)
                    .fontWeight(.medium)
                    .lineLimit(1)

                if !operation.category.isEmpty {

                    Text(operation.category)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            Text(operation.formattedAmount)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundStyle(amountColor)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            AppTheme.cardBackground
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: AppTheme.cornerRadius
            )
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: AppTheme.cornerRadius
            )
            .stroke(
                Color.primary.opacity(0.08),
                lineWidth: 1
            )
        )
    }
}
