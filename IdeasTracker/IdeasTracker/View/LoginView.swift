//
//  LoginView.swift
//  IdeasTracker
//
//  Created by Wen Yu Ge on 2024-04-19.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isRegister: Bool = false
    @State private var error: String = ""
    @FocusState private var focusedTextField: FormTextField?
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @EnvironmentObject private var router: Router
    
    enum FormTextField {
        case email, password
    }
    
    private func handleRegister() async {
        do {
            try await loginViewModel.register(
                email: email,
                password: password
            )
        }
        catch {
            print(error)
            self.error=error.localizedDescription
            // add your error handling here
        }
    }
    
    private func handleLogin() async {
        do {
            try await loginViewModel.login(
                email: email,
                password: password)
            router.pushReplacement(.ideas)
        }
        catch {
            print(error)
            self.error=error.localizedDescription
            // add your error handling here
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        TextField("Email", text: $email)
                            .focused($focusedTextField, equals: .email)
                            .onSubmit { focusedTextField = .password }
                            .submitLabel(.next)
                        
                        SecureField("Password", text: $password)
                            .focused($focusedTextField, equals: .password)
                            .onSubmit { focusedTextField = nil }
                            .submitLabel(.continue)
                        
                        if (!error.isEmpty){
                            Text(error)
                                .font(.footnote)
                                .foregroundColor(Color.red)
                        }
                    }
                    
                    Button(action: {
                        Task {
                            if isRegister {
                                await handleRegister()
                            } else {
                                await handleLogin()
                            }
                        }
                    }, label: {
                        Text(isRegister ? "Register" : "Login")
                    })
                    
                }
                
                Button(isRegister ? 
                       "Already have an account? Log in" :
                        "Don't have an account? Register"
                ) {
                    isRegister.toggle()
                }
            }
            .navigationTitle(isRegister ? "Create Account" : "Login")
        }
        .navigationBarBackButtonHidden(true)
    }
}

// Preview provider
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(LoginViewModel())
            .environmentObject(Router())
    }
}
