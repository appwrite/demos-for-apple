//
//  Idea.swift
//  IdeasTracker
//
//  Created by Wen Yu Ge on 2024-04-19.
//

import Foundation

struct Idea: Codable {
    init(userId: String, title: String, description: String) {
        self.userId = userId
        self.title = title
        self.description = description
    }
    var userId: String
    var title: String
    var description: String
}

struct IdeaItem: Identifiable {
    init(id: String, idea: Idea) {
        self.id = id
        self.idea = idea
    }
    var id: String
    var idea: Idea
}
