//
//  AuthenticationView.swift
//  example-auth
//

import Appwrite
import SwiftUI

enum AuthState {
    case register
    case login
    case session(AppwriteUser)
}

struct AuthenticationView: View {
    @EnvironmentObject var appwrite: AppwriteClient
    @State var state: AuthState = .login
    
    var body: some View {
        VStack {
            switch state {
            case .register:
                RegistrationView(
                    onComplete: { appwriteUser in
                        self.state = .session(appwriteUser)
                    },
                    shouldShowLogin: {
                        self.state = .login
                    }
                )
            case .login:
                LoginView(
                    onComplete: { appwriteUser in
                        self.state = .session(appwriteUser)
                    },
                    shouldShowRegistration: {
                        self.state = .register
                    }
                )
            case .session(let appwriteUser):
                SessionView(
                    user: appwriteUser,
                    onLogOut: {
                        self.state = .login
                    }
                )
            }
        }
        .onAppear(perform: attemptResumeSession)
    }
    
    @MainActor
    func attemptResumeSession() {
        Task {
            do {
                self.state = .session(
                    try await appwrite.getCurrentUser()
                )
            } catch {
                print(error)
                self.state = .login
            }
        }
    }
}
