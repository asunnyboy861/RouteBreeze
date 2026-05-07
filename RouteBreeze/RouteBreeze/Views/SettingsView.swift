import SwiftUI

struct SettingsView: View {
    @Bindable var purchaseManager: PurchaseManager
    @State private var showingPaywall = false
    @State private var showingContactSupport = false

    private let supportURL = "https://asunnyboy861.github.io/RouteBreeze/support.html"
    private let privacyURL = "https://asunnyboy861.github.io/RouteBreeze/privacy.html"
    private let termsURL = "https://asunnyboy861.github.io/RouteBreeze/terms.html"

    var body: some View {
        NavigationStack {
            Form {
                if purchaseManager.isProUser {
                    Section("Subscription") {
                        HStack {
                            Image(systemName: "crown.fill")
                                .foregroundStyle(.orange)
                            Text("RouteBreeze Pro")
                                .font(.headline)
                            Spacer()
                            Text("Active")
                                .foregroundStyle(.green)
                                .font(.subheadline)
                        }
                        Button("Restore Purchases") {
                            Task {
                                await purchaseManager.restorePurchases()
                            }
                        }
                    }
                } else {
                    Section("Upgrade") {
                        Button {
                            showingPaywall = true
                        } label: {
                            HStack {
                                Image(systemName: "crown.fill")
                                    .foregroundStyle(.orange)
                                Text("Upgrade to Pro")
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                Section("About") {
                    Link("Support", destination: URL(string: supportURL)!)
                    Link("Privacy Policy", destination: URL(string: privacyURL)!)
                    Link("Terms of Use", destination: URL(string: termsURL)!)
                }

                Section("Feedback") {
                    Button {
                        showingContactSupport = true
                    } label: {
                        Label("Contact Support", systemImage: "envelope")
                    }
                }

                Section {
                    HStack {
                        Spacer()
                        Text("RouteBreeze v1.0.0")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingPaywall) {
                PaywallView(purchaseManager: purchaseManager)
            }
            .sheet(isPresented: $showingContactSupport) {
                ContactSupportView()
            }
        }
    }
}
