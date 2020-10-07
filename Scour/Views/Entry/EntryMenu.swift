//
//  EntryMenu.swift
//  Scour
//
//  Created by Paul Thrasher on 10/6/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

struct EntryMenu: View {
    var model: CommitModel
    
    init(model: CommitModel) {
        self.model = model
        model.load()
    }
    
    var body: some View {
        EntryList(entries: model.entries)
            .navigationTitle("Entries")
    }
    
}
