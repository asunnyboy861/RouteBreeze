import CoreLocation
import MapKit

actor GeocodingService {

    func geocode(address: String) async throws -> CLLocationCoordinate2D {
        let geocoder = CLGeocoder()
        let placemarks = try await geocoder.geocodeAddressString(address)
        guard let location = placemarks.first?.location else {
            throw GeocodingError.notFound
        }
        return location.coordinate
    }

    func reverseGeocode(coordinate: CLLocationCoordinate2D) async throws -> String {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        guard let placemark = placemarks.first else {
            throw GeocodingError.notFound
        }
        return formatAddress(from: placemark)
    }

    private func formatAddress(from placemark: CLPlacemark) -> String {
        var components: [String] = []
        if let street = placemark.thoroughfare { components.append(street) }
        if let city = placemark.locality { components.append(city) }
        if let state = placemark.administrativeArea { components.append(state) }
        return components.joined(separator: ", ")
    }

    enum GeocodingError: Error, LocalizedError {
        case notFound
        case networkError

        var errorDescription: String? {
            switch self {
            case .notFound: return "Address not found. Please try a different address."
            case .networkError: return "Network error. Please check your connection."
            }
        }
    }
}
