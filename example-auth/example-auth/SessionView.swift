//
//  SessionView.swift
//  example-auth
//

import SwiftUI

struct SessionView: View {
    @EnvironmentObject var appwrite: AppwriteClient
    
    let user: AppwriteUser
    let onLogOut: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Hello, \(user.name)")
                .font(.title)
            
            Spacer()
            
            Button("Log Out", action: { logOut() })
            .buttonStyle(.borderedProminent)
        }
    }
    
    @MainActor
    func logOut() {
        Task {
            do {
                try await appwrite.logOutUser()
                onLogOut()
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    SessionView(
        user: AppwriteUser.from(map: [
            "$id": "",
            "$createdAt": "",
            "$updatedAt": "",
            "name": "Appwrite Community",
            "registration": "",
            "status": true,
            "labels": [],
            "passwordUpdate": "",
            "email": "",
            "phone": "",
            "emailVerification": true,
            "phoneVerification": true,
            "prefs": ["data": ""],
            "accessedAt": ""
        ]),
        onLogOut: {}
    )
}
