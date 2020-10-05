//
//  ScourApp.swift
//  Scour
//
//  Created by Paul Thrasher on 9/21/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

@main
struct ScourApp: App {
    @StateObject private var model = ScourModel()
    @StateObject private var store = UrlStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView(store: model, commitsModel: CommitsModel())
                .environmentObject(model)
                .environmentObject(store)
        }
        .commands {
            SidebarCommands()
        }
    }
}
