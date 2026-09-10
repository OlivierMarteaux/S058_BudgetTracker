import WidgetKit
import SwiftUI

struct BudgetTrackerWidgetEntry: TimelineEntry {
    let date: Date
}

struct BudgetTrackerWidgetProvider:
    TimelineProvider {

    func placeholder(
        in context: Context
    ) -> BudgetTrackerWidgetEntry {
        BudgetTrackerWidgetEntry(
            date: Date()
        )
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (
            BudgetTrackerWidgetEntry
        ) -> Void
    ) {
        completion(
            BudgetTrackerWidgetEntry(
                date: Date()
            )
        )
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (
            Timeline<BudgetTrackerWidgetEntry>
        ) -> Void
    ) {

        let entry = BudgetTrackerWidgetEntry(
            date: Date()
        )

        let timeline = Timeline(
            entries: [entry],
            policy: .never
        )

        completion(timeline)
    }
}

struct BudgetTrackerWidgetEntryView: View {

    let entry: BudgetTrackerWidgetEntry

    var body: some View {

        VStack(spacing: 10) {

            Image(systemName: "eurosign.circle.fill")
                .font(.system(size: 34))
                .foregroundStyle(
                    Color.blue
                )

            Text("Add operation")
                .font(.headline)

            Text("Tap to continue")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .widgetURL(
            URL(
                string:
                    "budgettracker://add-operation"
            )
        )
        .containerBackground(
            .fill.tertiary,
            for: .widget
        )
    }
}

struct BudgetTrackerWidget: Widget {

    let kind = "BudgetTrackerWidget"

    var body: some WidgetConfiguration {

        StaticConfiguration(
            kind: kind,
            provider:
                BudgetTrackerWidgetProvider()
        ) { entry in

            BudgetTrackerWidgetEntryView(
                entry: entry
            )
        }
        .configurationDisplayName(
            "Add operation"
        )
        .description(
            "Quickly add a new budget operation."
        )
        .supportedFamilies([
            .systemSmall
        ])
    }
}

#Preview(as: .systemSmall) {

    BudgetTrackerWidget()

} timeline: {

    BudgetTrackerWidgetEntry(
        date: .now
    )
}
