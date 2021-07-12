//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by Anthony Da Cruz on 12/01/2021.
//

import SwiftUI

@main
struct RickAndMortyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(apiData: RickMortyAPI())
        }
    }
}
