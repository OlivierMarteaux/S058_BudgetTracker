//
//  BottomNavigationBar.swift
//  BudgetTracker
//

import SwiftUI

enum AppTab: Hashable {

    case operations
    case recap
    case history
    case categories

    var title: String {

        switch self {
        case .operations:
            return "Operations"
            
        case .recap:
            return "Recap"
            
        case .history:
            return "History"
        
        case .categories:
            return "Categories"
        }
    }

    var icon: String {

        switch self {
        case .operations:
            return "list.bullet.rectangle"

        case .recap:
            return "calendar"

        case .history:
            return "chart.xyaxis.line"
            
        case .categories:
            return "folder"
        }
    }
}

struct BottomNavigationBar: View {

    @Binding var selectedTab: AppTab

    var body: some View {

        HStack {

            tabButton(
                .operations
            )

            Spacer()

            tabButton(
                .recap
            )

            Spacer()

            tabButton(
                .history
            )
        }
        .padding(
            .horizontal,
            30
        )
        .padding(.vertical, 10)
        .background(
            .ultraThinMaterial
        )
    }

    @ViewBuilder
    private func tabButton(
        _ tab: AppTab
    ) -> some View {

        Button {

            selectedTab = tab

        } label: {

            VStack(spacing: 4) {

                Image(
                    systemName: tab.icon
                )

                Text(tab.title)
                    .font(.caption)
            }
            .foregroundStyle(
                selectedTab == tab
                    ? AppTheme.primaryBlue
                    : .secondary
            )
        }
        .frame(
            minWidth: 70
        )
    }
}
