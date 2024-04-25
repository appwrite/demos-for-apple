//
//  ContentView.swift
//  IdeasTracker
//
//  Created by Wen Yu Ge on 2024-04-19.
//

import Foundation
import SwiftUI

struct SplashView: View {
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var loginViewModel: LoginViewModel
    
    var body: some View {
        NavigationStack(path: $router.routes) {
            VStack {
                Text("Welcome to Ideas Tracker")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
            }.task {
                let isLoggedIn = await self.loginViewModel.checkLoggedIn();

                if !isLoggedIn {
                    router.pushReplacement(.login)
                } else {
                    router.pushReplacement(.ideas)
                }
            }
            .navigationDestination(for: Route.self, destination: { $0 })

        }
    }
}
