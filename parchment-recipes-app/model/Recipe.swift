//
//  Recipe.swift
//  parchment-recipes-app
//
//  Created by Michael Hayes on 8/1/24.
//

import Foundation

struct Recipe : Codable, Identifiable {
    let id: Int
    var title: String
    var sourceUrl: String
    var ingredients: [Ingredient]
    var directions: [Direction]
}
