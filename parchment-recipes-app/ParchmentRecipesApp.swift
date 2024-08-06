//
//  parchment_recipes_appApp.swift
//  parchment-recipes-app
//
//  Created by Michael Hayes on 8/1/24.
//

import SwiftUI

@main
struct ParchmentRecipesApp: App {
    @StateObject var user: UserManager = UserManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(user)
        }
        
    }
}
