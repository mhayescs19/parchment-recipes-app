//
//  RecipeError.swift
//  parchment-recipes-app
//
//  Created by Michael Hayes on 8/1/24.
//

import Foundation

enum RecipeError: Error {
    case invalidUrl
    case resourceNotFound
    case dataMalformed
}
