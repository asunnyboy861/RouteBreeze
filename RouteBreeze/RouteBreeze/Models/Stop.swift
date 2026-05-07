import SwiftData
import CoreLocation
import MapKit

@Model
final class Stop {
    @Attribute(.unique) var id: UUID
    var title: String
    var address: String
    var latitude: Double
    var longitude: Double
    var serviceDuration: Int
    var priority: Int
    var timeWindowStart: Date?
    var timeWindowEnd: Date?
    var isCompleted: Bool
    var orderInRoute: Int
    var notes: String
    var route: Route?

    init(title: String = "", address: String = "", latitude: Double = 0, longitude: Double = 0) {
        self.id = UUID()
        self.title = title
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.serviceDuration = 15
        self.priority = 0
        self.isCompleted = false
        self.orderInRoute = 0
        self.notes = ""
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
