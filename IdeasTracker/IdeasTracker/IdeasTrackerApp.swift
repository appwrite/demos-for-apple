//
//  IdeasTrackerApp.swift
//  IdeasTracker
//
//  Created by Wen Yu Ge on 2024-04-19.
//

import SwiftUI

@main
struct IdeasTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(Router())
                .environmentObject(LoginViewModel())
        }
    }
}
