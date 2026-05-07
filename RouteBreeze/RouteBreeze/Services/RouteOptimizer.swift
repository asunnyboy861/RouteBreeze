import CoreLocation
import Foundation

struct OptimizationResult {
    let optimizedOrder: [Int]
    let totalDistance: Double
    let totalDuration: TimeInterval
    let savings: Double
}

final class RouteOptimizer {

    private let distanceMatrix: [[Double]]
    private let stops: [Stop]

    init(stops: [Stop]) {
        self.stops = stops
        self.distanceMatrix = RouteOptimizer.buildDistanceMatrix(from: stops)
    }

    func optimize() -> OptimizationResult {
        let nnResult = nearestNeighbor()
        let optimized = twoOpt(improve: nnResult)
        let originalDistance = calculateSequentialDistance()
        let savings = originalDistance > 0 ? (originalDistance - optimized.totalDistance) / originalDistance * 100 : 0
        return OptimizationResult(
            optimizedOrder: optimized.order,
            totalDistance: optimized.totalDistance,
            totalDuration: optimized.totalDistance / 500,
            savings: max(0, savings)
        )
    }

    private static func buildDistanceMatrix(from stops: [Stop]) -> [[Double]] {
        let n = stops.count
        var matrix = Array(repeating: Array(repeating: 0.0, count: n), count: n)
        for i in 0..<n {
            for j in 0..<n where i != j {
                let loc1 = CLLocation(latitude: stops[i].latitude, longitude: stops[i].longitude)
                let loc2 = CLLocation(latitude: stops[j].latitude, longitude: stops[j].longitude)
                matrix[i][j] = loc1.distance(from: loc2)
            }
        }
        return matrix
    }

    private func nearestNeighbor() -> (order: [Int], totalDistance: Double) {
        let n = stops.count
        guard n > 0 else { return ([], 0) }
        var visited = Array(repeating: false, count: n)
        var order: [Int] = [0]
        visited[0] = true
        var totalDistance = 0.0

        for _ in 1..<n {
            let last = order.last!
            var nearest = -1
            var nearestDist = Double.infinity
            for j in 0..<n where !visited[j] {
                if distanceMatrix[last][j] < nearestDist {
                    nearestDist = distanceMatrix[last][j]
                    nearest = j
                }
            }
            if nearest >= 0 {
                order.append(nearest)
                visited[nearest] = true
                totalDistance += nearestDist
            }
        }
        return (order, totalDistance)
    }

    private func twoOpt(improve initial: (order: [Int], totalDistance: Double)) -> (order: [Int], totalDistance: Double) {
        var route = initial.order
        var bestDistance = initial.totalDistance
        var improved = true

        while improved {
            improved = false
            for i in 1..<(route.count - 1) {
                for j in (i + 1)..<route.count {
                    let newRoute = reverseSegment(route, from: i, to: j)
                    let newDistance = calculateRouteDistance(newRoute)
                    if newDistance < bestDistance {
                        route = newRoute
                        bestDistance = newDistance
                        improved = true
                    }
                }
            }
        }
        return (route, bestDistance)
    }

    private func reverseSegment(_ route: [Int], from i: Int, to j: Int) -> [Int] {
        var newRoute = route
        newRoute.replaceSubrange(i...j, with: route[i...j].reversed())
        return newRoute
    }

    private func calculateRouteDistance(_ order: [Int]) -> Double {
        var total = 0.0
        for i in 0..<(order.count - 1) {
            total += distanceMatrix[order[i]][order[i + 1]]
        }
        return total
    }

    private func calculateSequentialDistance() -> Double {
        var total = 0.0
        for i in 0..<(stops.count - 1) {
            total += distanceMatrix[i][i + 1]
        }
        return total
    }
}
