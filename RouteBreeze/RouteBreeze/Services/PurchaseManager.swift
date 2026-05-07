import StoreKit
import SwiftUI

@Observable
final class PurchaseManager {

    enum SubscriptionTier: String, CaseIterable {
        case monthly = "com.zzoutuo.RouteBreeze.monthly"
        case yearly = "com.zzoutuo.RouteBreeze.yearly"
        case lifetime = "com.zzoutuo.RouteBreeze.lifetime"
    }

    var isProUser: Bool = false
    var products: [Product] = []
    var purchasedProductIDs: Set<String> = []

    private var updatesTask: Task<Void, Never>?

    init() {
        updatesTask = listenForTransactions()
        Task {
            await loadProducts()
            await updatePurchasedStatus()
        }
    }

    func loadProducts() async {
        do {
            let storeProducts = try await Product.products(for: SubscriptionTier.allCases.map { $0.rawValue })
            products = storeProducts.sorted { $0.price < $1.price }
        } catch {
            print("Failed to load products: \(error)")
        }
    }

    func purchase(_ product: Product) async throws -> StoreKit.Transaction? {
        let result = try await product.purchase()
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await updatePurchasedStatus()
            await transaction.finish()
            return transaction
        case .userCancelled:
            return nil
        case .pending:
            return nil
        @unknown default:
            return nil
        }
    }

    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updatePurchasedStatus()
        } catch {
            print("Failed to restore purchases: \(error)")
        }
    }

    var freeStopLimit: Int {
        isProUser ? .max : 15
    }

    var freeRouteLimit: Int {
        isProUser ? .max : 3
    }

    var canUseTemplates: Bool {
        isProUser
    }

    var canSetServiceDuration: Bool {
        isProUser
    }

    var canSetPriority: Bool {
        isProUser
    }

    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached {
            for await result in Transaction.updates {
                if let transaction = try? self.checkVerified(result) {
                    await self.updatePurchasedStatus()
                    await transaction.finish()
                }
            }
        }
    }

    nonisolated private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }

    private func updatePurchasedStatus() async {
        var purchasedIDs: Set<String> = []
        for await result in Transaction.currentEntitlements {
            if let transaction = try? checkVerified(result) {
                purchasedIDs.insert(transaction.productID)
            }
        }
        purchasedProductIDs = purchasedIDs
        isProUser = !purchasedIDs.isEmpty
    }

    enum StoreError: Error {
        case failedVerification
    }
}
