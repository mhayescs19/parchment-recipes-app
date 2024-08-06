//
//  UserManager.swift
//  parchment-recipes-app
//
//  Created by Michael Hayes on 8/5/24.
//

import Foundation

class UserManager: ObservableObject {
    @Published var recipes: [Recipe] = []
    
    func getAllRecipes() async throws -> [Recipe] {
        let apiEndpoint = "http://localhost:8080/api/recipe/"
        
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
            return try decoder.decode([Recipe].self, from: data) // decode data (JSON) into Recipe (model)
        } catch {
            throw RecipeError.dataMalformed
        }
    }
    
    func patchRecipe(recipeId: Int, recipeDto: RecipeDto) async throws {
        let apiEndpoint = "http://localhost:8080/api/recipe/\(recipeId)"
        
        guard let url: URL = URL(string: apiEndpoint) else { // URL is an optional, so handle the optional case with else
            throw RecipeError.invalidUrl
        }
        
        // format patch request
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let patch = try JSONEncoder().encode(recipeDto)
            let (_, response) = try await URLSession.shared.upload(for: request, from: patch)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { // optionally cast response as HTTPURLResponse, verify response code is OK
                throw RecipeError.resourceNotFound
            }
        } catch {
            print(error)
        }
    }
    
    func getRecipe(id: Int) async throws -> Recipe {
        let apiEndpoint = "http://localhost:8080/api/recipe/\(id)"
        
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
    
}
