//
//  ContentView.swift
//  parchment-recipes-app
//
//  Created by Michael Hayes on 8/1/24.
//

import SwiftUI

struct ContentView: View {
    @State private var recipe: Recipe? // optional bc when view loads, the object does not have data from api call
    @State private var text: String = "placeholder"
    
    var body: some View {
        VStack {
            Text(recipe?.title ?? "Recipe Title")
            Text(recipe?.sourceUrl ?? "URL")
            
            if let ingredients = recipe?.ingredients {
                List(ingredients) { ingredient in
                    TextField("\(ingredient.amount) \(ingredient.unit) \(ingredient.ingredientType)", text: $text)
                    HStack {
                        Text("\(ingredient.amount)")
                        Text(ingredient.unit)
                        Text(ingredient.ingredientType)
                    }
                }
                    .scrollDisabled(true)
            }
            
            
            if let directions = recipe?.directions {
                List(directions) { direction in
                    VStack {
                        Text(direction.content)
                    }
                }.scrollDisabled(true)
            }
        }
        .task {
            do {
                recipe = try await getRecipe()
            } catch RecipeError.invalidUrl {
                print("error processing data")
            } catch {
                print("unknown error")
            }
        }
    }
}

// eventually refactor into view model
func getRecipe() async throws -> Recipe {
    let apiEndpoint = "http://localhost:8080/api/recipe/1"
    
    guard let url: URL = URL(string: apiEndpoint) else { // URL is an optional, so handle the optional case with else
        throw RecipeError.invalidUrl
    }
    // tuple for data and response code
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { // optionally cast response as HTTPURLResponse, verify response code is OK
        throw RecipeError.resourceNotFound
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(Recipe.self, from: data) // decode data (JSON) into Recipe (model)
    } catch {
        throw RecipeError.dataMalformed
    }
}

#Preview {
    ContentView()
}
