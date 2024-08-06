//
//  ContentView.swift
//  parchment-recipes-app
//
//  Created by Michael Hayes on 8/1/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var user: UserManager
    
    enum RecipeFieldType {
        case title
    }

    @State private var originalText: String = ""
    
    var body: some View {
        List {
            ForEach($user.recipes) { $recipe in
                TextField(recipe.title, text: $recipe.title, onEditingChanged: { isEditing in
                    if !isEditing {
                        print("done editing")
                        if originalText == recipe.title {
                            Task {
                                do {
                                    try await user.patchRecipe(recipeId: recipe.id, recipeDto: RecipeDto(title: recipe.title))
                                } catch {
                                    print("unknown error")
                                }
                            }
                        }
                    } else {
                        self.originalText = recipe.title
                    }
                }
                )
                    .onSubmit {
                        print("Submit")
                    }
            }
        }
        .listStyle(.plain)
        .task {
            do {
                user.recipes = try await user.getAllRecipes()
            } catch RecipeError.invalidUrl {
                print("error processing data")
            } catch {
                print("unknown error")
            }
        }
        
        List (user.recipes) { recipe in
            Text(recipe.title)
        }
        /*
         VStack {
            Text( ?? "Recipe Title")
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
                user.recipes = try await user.getAllRecipes()
            } catch RecipeError.invalidUrl {
                print("error processing data")
            } catch {
                print("unknown error")
            }
        }*/
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
        .environmentObject(UserManager())
}
