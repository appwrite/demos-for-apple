//
//  LoginView.swift
//  example-auth
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appwrite: AppwriteClient
    @State var email: String = ""
    @State var password: String = ""
    
    let onComplete: (AppwriteUser) -> Void
    let shouldShowRegistration: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            Button("Login", action: { login() })
                .buttonStyle(.borderedProminent)
            
            Spacer()
            
            Button(
                "Don't have an account? Sign up.",
                action: shouldShowRegistration
            )
        }
        .padding()
    }
    
    @MainActor
    func login() {
        Task {
            do {
                let user = try await appwrite.loginUser(
                    email: email,
                    password: password
                )
                self.onComplete(user)
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    LoginView(
        onComplete: {_ in},
        shouldShowRegistration: {}
    )
}
