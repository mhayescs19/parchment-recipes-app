//
//  RecipeDto.swift
//  parchment-recipes-app
//
//  Created by Michael Hayes on 8/5/24.
//

import Foundation

struct RecipeDto: Codable {
    //let id: Int?
    var title: String?
    var sourceUrl: String?
    var description: String?
    var ingredients: [Ingredient]?
    var directions: [Direction]?
}
