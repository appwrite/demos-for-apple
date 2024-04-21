//
//  Idea.swift
//  IdeasTracker
//
//  Created by Wen Yu Ge on 2024-04-19.
//

import Foundation

struct Idea: Codable {
    var userId: String
    var title: String
    var description: String
}

struct IdeaItem: Identifiable {
    var id: String
    var idea: Idea
}
