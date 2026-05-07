import SwiftUI
import SwiftData

@main
struct RouteBreezeApp: App {
    let purchaseManager = PurchaseManager()

    var body: some Scene {
        WindowGroup {
            ContentView(purchaseManager: purchaseManager)
        }
        .modelContainer(for: [Route.self, Stop.self])
    }
}
