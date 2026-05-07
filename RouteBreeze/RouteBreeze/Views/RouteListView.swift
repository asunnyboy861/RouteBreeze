import SwiftUI
import SwiftData

struct RouteListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Route.createdAt, order: .reverse) private var routes: [Route]
    @State private var showingAddRoute = false
    @State private var routeToEdit: Route?
    @State private var showingPaywall = false
    @Bindable var purchaseManager: PurchaseManager

    var body: some View {
        NavigationStack {
            Group {
                if routes.isEmpty {
                    ContentUnavailableView(
                        "No Routes Yet",
                        systemImage: "map",
                        description: Text("Create your first route to start optimizing your daily stops.")
                    )
                } else {
                    List {
                        ForEach(routes) { route in
                            NavigationLink(destination: RouteMapView(route: route, purchaseManager: purchaseManager)) {
                                RouteRowView(route: route)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    deleteRoute(route)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    duplicateRoute(route)
                                } label: {
                                    Label("Duplicate", systemImage: "doc.on.doc")
                                }
                                .tint(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle("RouteBreeze")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if !purchaseManager.isProUser && routes.count >= purchaseManager.freeRouteLimit {
                            showingPaywall = true
                        } else {
                            showingAddRoute = true
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddRoute) {
                AddRouteView(purchaseManager: purchaseManager)
            }
            .sheet(item: $routeToEdit) { route in
                EditRouteNameView(route: route)
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView(purchaseManager: purchaseManager)
            }
        }
    }

    private func deleteRoute(_ route: Route) {
        modelContext.delete(route)
    }

    private func duplicateRoute(_ route: Route) {
        let newRoute = Route(name: "\(route.name) Copy")
        newRoute.isTemplate = route.isTemplate
        for stop in route.sortedStops {
            let newStop = Stop(title: stop.title, address: stop.address, latitude: stop.latitude, longitude: stop.longitude)
            newStop.serviceDuration = stop.serviceDuration
            newStop.priority = stop.priority
            newStop.notes = stop.notes
            newStop.orderInRoute = stop.orderInRoute
            newStop.route = newRoute
            newRoute.stops.append(newStop)
        }
        modelContext.insert(newRoute)
    }
}

struct RouteRowView: View {
    let route: Route

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(route.name)
                    .font(.headline)
                Spacer()
                if route.isOptimized {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.caption)
                }
            }
            HStack {
                Label("\(route.stops.count) stops", systemImage: "mappin.and.ellipse")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(route.progressText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}

struct AddRouteView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var routeName = ""
    var purchaseManager: PurchaseManager

    var body: some View {
        NavigationStack {
            Form {
                TextField("Route Name", text: $routeName)
            }
            .navigationTitle("New Route")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        let route = Route(name: routeName.isEmpty ? "New Route" : routeName)
                        modelContext.insert(route)
                        dismiss()
                    }
                }
            }
        }
    }
}

struct EditRouteNameView: View {
    @Bindable var route: Route
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                TextField("Route Name", text: $route.name)
                Toggle("Save as Template", isOn: $route.isTemplate)
            }
            .navigationTitle("Edit Route")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
