import SwiftUI
import SwiftData
import CoreLocation

struct AddStopView: View {
    @Bindable var route: Route
    @Bindable var purchaseManager: PurchaseManager
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var address = ""
    @State private var isGeocoding = false
    @State private var geocodingError: String?
    @State private var searchResults: [CLLocationCoordinate2D] = []

    private let geocodingService = GeocodingService()

    var body: some View {
        NavigationStack {
            Form {
                Section("Stop Details") {
                    TextField("Title (optional)", text: $title)
                    TextField("Address", text: $address)
                        .onSubmit {
                            searchAddress()
                        }
                }

                if isGeocoding {
                    Section {
                        HStack {
                            Spacer()
                            ProgressView("Searching address...")
                            Spacer()
                        }
                    }
                }

                if let error = geocodingError {
                    Section {
                        Text(error)
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                }

                if !purchaseManager.canSetServiceDuration && !purchaseManager.isProUser {
                    Section {
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundStyle(.orange)
                            Text("Service duration and priority are Pro features")
                                .font(.caption)
                            Spacer()
                            Button("Upgrade") {
                                dismiss()
                            }
                            .font(.caption)
                            .buttonStyle(.bordered)
                        }
                    }
                }
            }
            .navigationTitle("Add Stop")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addStop()
                    }
                    .disabled(address.isEmpty && title.isEmpty)
                }
            }
        }
    }

    private func searchAddress() {
        guard !address.isEmpty else { return }
        isGeocoding = true
        geocodingError = nil
        Task {
            do {
                let coordinate = try await geocodingService.geocode(address: address)
                searchResults = [coordinate]
                isGeocoding = false
            } catch {
                geocodingError = error.localizedDescription
                isGeocoding = false
            }
        }
    }

    private func addStop() {
        Task {
            var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
            if !address.isEmpty {
                do {
                    coordinate = try await geocodingService.geocode(address: address)
                } catch {
                    geocodingError = error.localizedDescription
                    return
                }
            }

            let stop = Stop(
                title: title.isEmpty ? address : title,
                address: address,
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
            stop.orderInRoute = route.stops.count
            stop.route = route
            route.stops.append(stop)
            dismiss()
        }
    }
}
