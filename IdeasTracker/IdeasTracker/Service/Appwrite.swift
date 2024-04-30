//
//  File.swift
//  IdeasTracker
//
//  Created by Wen Yu Ge on 2024-04-19.
//

import Foundation
import Appwrite
import AppwriteModels
import JSONCodable

class Appwrite: ObservableObject {
    static let shared = Appwrite()

    var client: Client
    var account: Account
    var databases: Databases
    let databaseId = "default"
    let collectionId = "ideas-tracker"

    public init() {
        self.client = Client()
            .setEndpoint("https://cloud.appwrite.io/v1")
            .setProject("659f400f6aa16c45ad6c")
        
        self.account = Account(client)
        self.databases = Databases(client)
    }
    
    public func listIdeas() async throws ->
    DocumentList<Idea> {
        return try await self.databases.listDocuments<Idea>(
            databaseId: self.databaseId,
            collectionId: self.collectionId,
            queries: [
                Query.orderDesc("$createdAt"),
                Query.limit(10)
            ],
            nestedType: Idea.self
        )
    }
    
    public func removeIdea(id: String) async throws {
        _ = try await self.databases.deleteDocument(
            databaseId: self.databaseId,
            collectionId: self.collectionId,
            documentId: id
        )
    }
    
    public func addIdea(title: String, description: String, userId: String) async throws -> Document<Idea> {
        return try await self.databases.createDocument<Idea>(
            databaseId: self.databaseId,
            collectionId: self.collectionId,
            documentId: ID.unique(),
            data: Idea(
                userId: userId, 
                title: title,
                description: description
            ),
            permissions: [Permission.write(Role.user(userId))],
            nestedType: Idea.self
        )
    }
    
    public func getUser() async throws -> User<[String: AnyCodable]> {
        return try await account.get()
    }
    
    public func login(
        email: String,
        password: String
    )  async throws -> User<[String: AnyCodable]> {
        _ = try await account.createEmailSession(
            email: email,
            password: password
        )
        return try await account.get()
    }
    
    public func register(
        email: String,
        password: String
    ) async throws -> User<[String: AnyCodable]> {
        _ = try await account.create(
            userId: ID.unique(),
            email: email,
            password: password
        )
        return try await self.login(
            email: email,
            password: password
        )
    }
}

