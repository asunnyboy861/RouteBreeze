import SwiftData
import Foundation

@Model
final class Route {
    @Attribute(.unique) var id: UUID
    var name: String
    var createdAt: Date
    var isOptimized: Bool
    var totalDistance: Double
    var totalDuration: Double
    var startAddress: String?
    var endAddress: String?
    var isTemplate: Bool
    @Relationship(deleteRule: .cascade, inverse: \Stop.route)
    var stops: [Stop]

    init(name: String = "New Route") {
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
        self.isOptimized = false
        self.totalDistance = 0
        self.totalDuration = 0
        self.isTemplate = false
        self.stops = []
    }

    var sortedStops: [Stop] {
        stops.sorted { $0.orderInRoute < $1.orderInRoute }
    }

    var completedCount: Int {
        stops.filter { $0.isCompleted }.count
    }

    var progressText: String {
        "\(completedCount)/\(stops.count) stops"
    }
}
