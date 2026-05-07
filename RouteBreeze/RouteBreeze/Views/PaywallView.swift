import SwiftUI
import StoreKit

struct PaywallView: View {
    @Bindable var purchaseManager: PurchaseManager
    @Environment(\.dismiss) private var dismiss
    @State private var isPurchasing = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    featuresSection
                    pricingSection
                    restoreSection
                }
                .padding()
            }
            .navigationTitle("RouteBreeze Pro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
            .alert("Purchase Error", isPresented: .constant(errorMessage != nil), actions: {
                Button("OK") { errorMessage = nil }
            }, message: {
                Text(errorMessage ?? "")
            })
        }
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "crown.fill")
                .font(.system(size: 48))
                .foregroundStyle(.orange)
            Text("Unlock Full Power")
                .font(.title.bold())
            Text("Optimize unlimited stops, save route templates, and set service durations.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 8)
    }

    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            FeatureRow(icon: "infinity", title: "Unlimited Stops", description: "No 15-stop limit")
            FeatureRow(icon: "doc.on.doc", title: "Route Templates", description: "Save & reuse routes")
            FeatureRow(icon: "clock", title: "Service Duration", description: "Set time per stop")
            FeatureRow(icon: "flag", title: "Priority Stops", description: "Mark important stops")
            FeatureRow(icon: "wifi.slash", title: "Offline Optimization", description: "Works without internet")
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var pricingSection: some View {
        VStack(spacing: 12) {
            ForEach(purchaseManager.products, id: \.id) { product in
                Button {
                    purchaseProduct(product)
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(product.displayName)
                                .font(.headline)
                            Text(product.description)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(product.displayPrice)
                            .font(.title3.bold())
                    }
                    .padding()
                    .background(Color.accentColor.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                .disabled(isPurchasing)
            }
        }
    }

    private var restoreSection: some View {
        Button("Restore Purchases") {
            Task {
                await purchaseManager.restorePurchases()
                if purchaseManager.isProUser {
                    dismiss()
                }
            }
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }

    private func purchaseProduct(_ product: Product) {
        isPurchasing = true
        Task {
            do {
                let transaction = try await purchaseManager.purchase(product)
                if transaction != nil {
                    dismiss()
                }
            } catch {
                errorMessage = error.localizedDescription
            }
            isPurchasing = false
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(Color.accentColor)
                .frame(width: 32)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.bold())
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
