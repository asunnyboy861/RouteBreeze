import SwiftUI
import MapKit
import SwiftData

struct RouteMapView: View {
    @Bindable var route: Route
    @Bindable var purchaseManager: PurchaseManager
    @Environment(\.modelContext) private var modelContext
    @State private var position: MapCameraPosition = .automatic
    @State private var selectedStop: Stop?
    @State private var isOptimizing = false
    @State private var optimizationSavings: Double?
    @State private var showingAddStop = false
    @State private var showingPaywall = false
    @State private var showingStopDetail: Stop?

    private let geocodingService = GeocodingService()
    private let navigationService = NavigationService()

    var body: some View {
        VStack(spacing: 0) {
            mapContent
            routeActionBar
        }
        .navigationTitle(route.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingAddStop = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddStop) {
            AddStopView(route: route, purchaseManager: purchaseManager)
        }
        .sheet(item: $showingStopDetail) { stop in
            EditStopView(stop: stop, purchaseManager: purchaseManager)
        }
        .sheet(isPresented: $showingPaywall) {
            PaywallView(purchaseManager: purchaseManager)
        }
    }

    private var mapContent: some View {
        Map(position: $position, selection: $selectedStop) {
            ForEach(Array(route.sortedStops.enumerated()), id: \.element.id) { index, stop in
                Annotation("\(index + 1)", coordinate: stop.coordinate) {
                    StopMarkerView(index: index + 1, isCompleted: stop.isCompleted, priority: stop.priority)
                        .onTapGesture {
                            showingStopDetail = stop
                        }
                }
            }

            if route.sortedStops.count >= 2 {
                MapPolyline(coordinates: route.sortedStops.map { $0.coordinate })
                    .stroke(.blue, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
            }
        }
        .mapStyle(.standard)
        .safeAreaInset(edge: .bottom) {
            if let savings = optimizationSavings {
                savingsBanner(savings: savings)
            }
        }
    }

    private var routeActionBar: some View {
        VStack(spacing: 0) {
            if route.stops.count > 0 {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Array(route.sortedStops.enumerated()), id: \.element.id) { index, stop in
                            StopChipView(index: index + 1, stop: stop)
                                .onTapGesture {
                                    withAnimation {
                                        position = .region(MKCoordinateRegion(
                                            center: stop.coordinate,
                                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                        ))
                                    }
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
            }

            HStack(spacing: 12) {
                Button {
                    optimizeRoute()
                } label: {
                    if isOptimizing {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Label("Optimize", systemImage: "arrow.triangle.swap")
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(isOptimizing || route.stops.count < 2)

                Menu {
                    Button {
                        navigationService.openNavigation(to: route.sortedStops.first!, app: .appleMaps)
                    } label: {
                        Label("Apple Maps", systemImage: "map")
                    }
                    Button {
                        navigationService.openNavigation(to: route.sortedStops.first!, app: .googleMaps)
                    } label: {
                        Label("Google Maps", systemImage: "globe")
                    }
                    Button {
                        navigationService.openNavigation(to: route.sortedStops.first!, app: .waze)
                    } label: {
                        Label("Waze", systemImage: "car")
                    }
                } label: {
                    Image(systemName: "navigation")
                }
                .buttonStyle(.bordered)
                .disabled(route.sortedStops.isEmpty)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .background(.bar)
    }

    private func savingsBanner(savings: Double) -> some View {
        HStack {
            Image(systemName: "leaf.fill")
                .foregroundStyle(.green)
            Text(String(format: "Route optimized — %.0f%% shorter!", savings))
                .font(.subheadline.bold())
                .foregroundStyle(.green)
            Spacer()
        }
        .padding()
        .background(.green.opacity(0.1))
    }

    private func optimizeRoute() {
        isOptimizing = true
        let sortedStops = route.sortedStops
        let optimizer = RouteOptimizer(stops: sortedStops)
        let result = optimizer.optimize()

        for (newIndex, originalIndex) in result.optimizedOrder.enumerated() {
            sortedStops[originalIndex].orderInRoute = newIndex
        }
        route.isOptimized = true
        route.totalDistance = result.totalDistance
        route.totalDuration = result.totalDuration
        optimizationSavings = result.savings
        isOptimizing = false
    }
}

struct StopMarkerView: View {
    let index: Int
    let isCompleted: Bool
    let priority: Int

    var body: some View {
        ZStack {
            Circle()
                .fill(markerColor)
                .frame(width: 32, height: 32)
                .shadow(radius: 2)
            if isCompleted {
                Image(systemName: "checkmark")
                    .font(.caption.bold())
                    .foregroundStyle(.white)
            } else {
                Text("\(index)")
                    .font(.caption.bold())
                    .foregroundStyle(.white)
            }
        }
    }

    private var markerColor: Color {
        if isCompleted { return .green }
        switch priority {
        case 1: return .orange
        case 2: return .red
        default: return .blue
        }
    }
}

struct StopChipView: View {
    let index: Int
    let stop: Stop

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(stop.isCompleted ? Color.green : Color.blue)
                .frame(width: 8, height: 8)
            Text(stop.title.isEmpty ? "Stop \(index)" : stop.title)
                .font(.caption)
                .lineLimit(1)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
    }
}
