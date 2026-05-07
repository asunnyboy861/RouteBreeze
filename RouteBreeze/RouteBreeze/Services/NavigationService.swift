import MapKit
import UIKit

final class NavigationService {

    enum NavigationApp {
        case appleMaps
        case googleMaps
        case waze
    }

    func openNavigation(to stop: Stop, app: NavigationApp = .appleMaps) {
        switch app {
        case .appleMaps:
            openAppleMaps(to: stop)
        case .googleMaps:
            openGoogleMaps(to: stop)
        case .waze:
            openWaze(to: stop)
        }
    }

    private func openAppleMaps(to stop: Stop) {
        let coordinate = stop.coordinate
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = stop.title
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
            MKLaunchOptionsShowsTrafficKey: true
        ])
    }

    private func openGoogleMaps(to stop: Stop) {
        let urlString = "comgooglemaps://?daddr=\(stop.latitude),\(stop.longitude)&directionsmode=driving"
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    private func openWaze(to stop: Stop) {
        let urlString = "waze://?ll=\(stop.latitude),\(stop.longitude)&navigate=yes"
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
