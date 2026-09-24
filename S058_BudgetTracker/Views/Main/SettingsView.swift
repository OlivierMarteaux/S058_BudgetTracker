import SwiftUI

struct SettingsView: View {
    @AppStorage("selectedCurrency")
    private var selectedCurrency = Currency.eur.rawValue
    
    @Environment(\.dismiss)
    private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Currency") {
                    Picker("Currency", selection: $selectedCurrency) {
                        ForEach(Currency.allCases) { currency in
                            Text(currency.displayName)
                                .tag(currency.rawValue)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(
                    placement: .topBarTrailing
                ) {

                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
