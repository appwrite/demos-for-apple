//
//  RegistrationView.swift
//  example-auth
//

import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var appwrite: AppwriteClient
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    
    let onComplete: (AppwriteUser) -> Void
    let shouldShowLogin: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            TextField("Full name", text: $name)
                .textFieldStyle(.roundedBorder)
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            Button("Sign Up", action: { signUp() })
                .buttonStyle(.borderedProminent)
            
            Spacer()
            
            Button(
                "Already have an account? Log in.",
                action: shouldShowLogin
            )
        }
        .padding()
    }
    
    @MainActor
    func signUp() {
        Task {
            do {
                let user = try await appwrite.registerUser(
                    email: email,
                    password: password,
                    name: name
                )
                self.onComplete(user)
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    RegistrationView(
        onComplete: {_ in},
        shouldShowLogin: {}
    )
}
