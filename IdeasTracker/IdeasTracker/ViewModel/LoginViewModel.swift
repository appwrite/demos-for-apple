//
//  LoginViewModel.swift
//  IdeasTracker
//
//  Created by Wen Yu Ge on 2024-04-19.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var userId: String
    private var appwriteService: Appwrite
    
    init() {
        self.userId = ""
        self.appwriteService = Appwrite.shared
    }
    
    public func checkLoggedIn() async -> Bool {
        let user = try? await self.appwriteService.getUser()
        await MainActor.run {
            self.userId = user?.id ?? "";
        }
        return self.userId != ""
    }
    
    public func login(
        email: String,
        password: String
    ) async {
        let user = try? await self.appwriteService.login(
            email: email,
            password: password
        )
        await MainActor.run {
            self.userId = user?.id ?? ""
        }
    }
    
    @MainActor public func register(
        email: String,
        password: String
    ) async {
        let user = try? await self.appwriteService.register(
            email: email,
            password: password
        )
        self.userId = user?.id ?? ""
    }
}
