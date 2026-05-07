import SwiftUI

struct ContentView: View {
    @Bindable var purchaseManager: PurchaseManager
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            RouteListView(purchaseManager: purchaseManager)
                .tabItem {
                    Label("Routes", systemImage: "list.bullet")
                }
                .tag(0)

            NavigationStack {
                ContentUnavailableView(
                    "Select a Route",
                    systemImage: "map",
                    description: Text("Choose a route from the Routes tab to view it on the map.")
                )
            }
            .tabItem {
                Label("Map", systemImage: "map")
            }
            .tag(1)

            SettingsView(purchaseManager: purchaseManager)
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(2)
        }
    }
}
