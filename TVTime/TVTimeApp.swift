//
//  TVTimeApp.swift
//  TVTime
//
//  Created by Tyler Flowers on 6/14/24.
//

import SwiftUI

@main
struct TVTimeApp: App {
    @StateObject private var movieDb = APIConnect(baseURL: APIBASEURL)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(movieDb)
        }
    }
}
