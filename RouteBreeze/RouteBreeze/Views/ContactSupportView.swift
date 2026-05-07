import SwiftUI

struct ContactSupportView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var email = ""
    @State private var message = ""
    @State private var topic = "General"
    @State private var isSubmitting = false
    @State private var showSuccess = false
    @State private var showError = false

    private let topics = ["General", "Bug Report", "Feature Request", "Subscription Issue", "Other"]
    private let backendURL = "https://feedback-board.iocompile67692.workers.dev"

    var body: some View {
        NavigationStack {
            Form {
                Section("Topic") {
                    Picker("Topic", selection: $topic) {
                        ForEach(topics, id: \.self) { t in
                            Text(t).tag(t)
                        }
                    }
                }

                Section("Your Info") {
                    TextField("Name (optional)", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                }

                Section("Message") {
                    TextEditor(text: $message)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("Contact Support")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Send") {
                        submitFeedback()
                    }
                    .disabled(email.isEmpty || message.isEmpty || isSubmitting)
                }
            }
            .alert("Message Sent", isPresented: $showSuccess) {
                Button("OK") { dismiss() }
            } message: {
                Text("Thank you for contacting us. We will get back to you soon.")
            }
            .alert("Error", isPresented: $showError) {
                Button("OK") {}
            } message: {
                Text("Failed to send message. Please try again later.")
            }
        }
    }

    private func submitFeedback() {
        isSubmitting = true
        Task {
            do {
                var components = URLComponents(string: backendURL)!
                components.path = "/api/feedback"
                guard let url = components.url else { return }

                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

                let body: [String: String?] = [
                    "topic": topic,
                    "name": name,
                    "email": email,
                    "message": message
                ]
                request.httpBody = try JSONSerialization.data(withJSONObject: body.compactMapValues { $0 })

                let (_, response) = try await URLSession.shared.data(for: request)
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    showSuccess = true
                } else {
                    showError = true
                }
            } catch {
                showError = true
            }
            isSubmitting = false
        }
    }
}
