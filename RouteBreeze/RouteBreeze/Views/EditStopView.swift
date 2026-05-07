import SwiftUI

struct EditStopView: View {
    @Bindable var stop: Stop
    @Bindable var purchaseManager: PurchaseManager
    @Environment(\.dismiss) private var dismiss
    @State private var showingNavigationMenu = false

    private let navigationService = NavigationService()

    var body: some View {
        NavigationStack {
            Form {
                Section("Stop Details") {
                    TextField("Title", text: $stop.title)
                    TextField("Address", text: $stop.address)
                    TextField("Notes", text: $stop.notes, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section("Status") {
                    Toggle("Completed", isOn: $stop.isCompleted)
                }

                if purchaseManager.canSetServiceDuration {
                    Section("Service") {
                        Stepper("Duration: \(stop.serviceDuration) min", value: $stop.serviceDuration, in: 5...120, step: 5)
                    }
                }

                if purchaseManager.canSetPriority {
                    Section("Priority") {
                        Picker("Priority", selection: $stop.priority) {
                            Text("Normal").tag(0)
                            Text("Medium").tag(1)
                            Text("High").tag(2)
                        }
                        .pickerStyle(.segmented)
                    }
                }

                Section("Navigation") {
                    Button {
                        navigationService.openNavigation(to: stop, app: .appleMaps)
                    } label: {
                        Label("Navigate with Apple Maps", systemImage: "map")
                    }
                    Button {
                        navigationService.openNavigation(to: stop, app: .googleMaps)
                    } label: {
                        Label("Navigate with Google Maps", systemImage: "globe")
                    }
                    Button {
                        navigationService.openNavigation(to: stop, app: .waze)
                    } label: {
                        Label("Navigate with Waze", systemImage: "car")
                    }
                }
            }
            .navigationTitle(stop.title.isEmpty ? "Stop Details" : stop.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
