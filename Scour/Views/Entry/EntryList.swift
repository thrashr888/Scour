//
//  EntryList.swift
//  Scour
//
//  Created by Paul Thrasher on 10/6/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

struct EntryList: View {
    var entries: [EntryModel]
    
    @State private var selection: EntryModel?
    @EnvironmentObject private var model: ScourModel
    
    var body: some View {
        List(selection: $selection) {
            ForEach(entries.sorted()) { entry in
                if entry.isTree {
                    NavigationLink(
                        destination: EntryMenu(model: entry.parent).environmentObject(model),
                        tag: entry,
                        selection: $selection
                    ) {
                        EntryRow(entry: entry)
                    }
                    .tag(entry)
                } else {
                    NavigationLink(
                        destination: EntryView(entry: entry).environmentObject(model),
                        tag: entry,
                        selection: $selection
                    ) {
                        EntryRow(entry: entry)
                    }
                    .tag(entry)
                }
            }
        }
    }
}
