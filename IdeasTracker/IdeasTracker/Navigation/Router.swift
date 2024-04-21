//
//  Router.swift
//  IdeasTracker
//
//  Created by Wen Yu Ge on 2024-04-19.
//

import Foundation
import SwiftUI

enum Route {
    case ideas
    case login
}

extension Route: View {
    var body: some View {
        switch self {
        case .ideas:
            IdeasView()
        case .login:
            LoginView()
        }
    }
}

extension Route: Hashable {
    static func == (lhs: Route, rhs: Route) -> Bool {
        return lhs.compareString == rhs.compareString
    }

    var compareString: String {
        switch self {
        case .ideas:
            return "ideas"
        case .login:
            return "login"
        }
    }
}


final class Router: ObservableObject {
    @Published var routes = [Route]()

    func push(_ screen: Route) {
        routes.append(screen)
    }

    func pushReplacement(_ screen: Route) {
        if routes.isEmpty {
            routes.append(screen)
        } else {
            routes[routes.count - 1] = screen
        }
    }

    func pop() {
        routes.removeLast()
    }

    func popUntil(predicate: (Route) -> Bool) {
        if let last = routes.popLast() {
            guard predicate(last) else {
                popUntil(predicate: predicate)
                return
            }
        }
    }

    func reset() {
        routes = []
    }
}
