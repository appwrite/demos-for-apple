//
//  AppwriteClient.swift
//  example-auth
//

import Appwrite
import Foundation
import JSONCodable

public typealias AppwriteUser = User<[String: AnyCodable]>

public final class AppwriteClient: ObservableObject {
    private let client: Client
    private let account: Account
    
    public init() {
        self.client = Client()
            .setEndpoint("https://cloud.appwrite.io/v1")
            .setProject("65b477970040ded5ac11")
        
        self.account = Account(client)
    }
    
    public func registerUser(
        email: String,
        password: String,
        name: String
    ) async throws -> AppwriteUser {
        _ = try await account.create(
            userId: ID.unique(),
            email: email,
            password: password,
            name: name
        )
        
        return try await loginUser(
            email: email,
            password: password
        )
    }
    
    public func loginUser(
        email: String,
        password: String
    ) async throws -> AppwriteUser {
        _ = try await account.createEmailSession(
            email: email,
            password: password
        )
        
        return try await getCurrentUser()
    }
    
    public func logOutUser() async throws {
        _ = try await account.deleteSession(
            sessionId: "current"
        )
    }
    
    public func getCurrentUser() async throws -> AppwriteUser {
        let session = try await account.getSession(
            sessionId: "current"
        )
        
        if session.current {
            return try await account.get()
        } else {
            throw AppwriteClientError.invalidSession
        }
    }
}

public enum AppwriteClientError: Error {
    case invalidSession
}
