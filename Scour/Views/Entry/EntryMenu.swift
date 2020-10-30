//
//  EntryMenu.swift
//  Scour
//
//  Created by Paul Thrasher on 10/6/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

struct EntryMenu: View {
    @ObservedObject var model: CommitModel
    
    var body: some View {
        if model.error != nil {
            ErrorView(error: model.error!)
        }
        EntryList(commit: model, entries: model.entries)
            .navigationTitle("Entries")
            .onAppear {
                DispatchQueue.main.async {
                    model.load()
                }
            }
    }
    
}
