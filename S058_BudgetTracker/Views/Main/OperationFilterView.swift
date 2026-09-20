import SwiftUI

struct OperationFilterView: View {

    @Binding var category: String
    @Binding var dateFilter: OperationDateFilter

//    let categories: [String]
    let categories: [Category]

    @Environment(\.dismiss)
    private var dismiss

    @State private var dateOption: OperationDateFilterOption = .all
    @State private var customFromDate = Date()
    @State private var customToDate = Date()

    var body: some View {

        NavigationStack {

            Form {

                Section("Category") {

                    Picker(
                        "Category",
                        selection: $category
                    ) {

                        Text("All Categories")
                            .tag("All Categories")

//                        ForEach(categories, id: \.self) { category in
//
//                            Text(category)
//                                .tag(category)
//                        }
                        Text("None")
                            .tag("")
                        ForEach(categories) { category in
                            Text(category.name)
                                .tag(category.name)
                        }
                    }
                }

                Section("Date") {

                    Picker(
                        "Date",
                        selection: $dateOption
                    ) {

                        ForEach(
                            OperationDateFilterOption.allCases
                        ) { option in

                            Text(option.title)
                                .tag(option)
                        }
                    }

                    if dateOption == .custom {

                        DatePicker(
                            "From",
                            selection: $customFromDate,
                            displayedComponents: .date
                        )

                        DatePicker(
                            "To",
                            selection: $customToDate,
                            displayedComponents: .date
                        )
                    }
                }

                Section {

                    Button("Reset Filters") {

                        category = "All Categories"
                        dateOption = .all
                        dateFilter = .all
                    }
                    .foregroundStyle(.red)
                }
            }
            .navigationTitle("Filter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(
                    placement: .topBarTrailing
                ) {

                    Button("Done") {

                        applyDateFilter()
                        dismiss()
                    }
                }
            }
            .onAppear {

                switch dateFilter {

                case .all:
                    dateOption = .all

                case .thisMonth:
                    dateOption = .thisMonth

                case .lastMonth:
                    dateOption = .lastMonth

                case let .custom(from, to):
                    dateOption = .custom
                    customFromDate = from
                    customToDate = to
                }
            }
        }
    }

    private func applyDateFilter() {

        switch dateOption {

        case .all:
            dateFilter = .all

        case .thisMonth:
            dateFilter = .thisMonth

        case .lastMonth:
            dateFilter = .lastMonth

        case .custom:

            dateFilter = .custom(
                from: customFromDate,
                to: customToDate
            )
        }
    }
}
