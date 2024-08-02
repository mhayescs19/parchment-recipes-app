//
//  Ingredient.swift
//  parchment-recipes-app
//
//  Created by Michael Hayes on 8/1/24.
//

import Foundation

struct Ingredient : Codable, Identifiable {
    let id: Int
    var amount: Double
    var unit: String
    var ingredientType: String
}
