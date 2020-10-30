//
//  EntryList.swift
//  Scour
//
//  Created by Paul Thrasher on 10/6/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

struct EntryList: View {
    var commit: CommitModel
    var entries: [EntryModel]
    
    @State private var selection: EntryModel?
    @EnvironmentObject private var model: ScourModel
    
    var showLoading: some View {
        ProgressView().padding()
    }
    
    var body: some View {
        List(entries.sorted(), children: \.children, selection: $selection) { entry in
            NavigationLink(
                destination: EntryView(entry: entry).environmentObject(model),
                tag: entry,
                selection: $selection
            ) {
                EntryRow(entry: entry)
            }
            .tag(entry)
        }
        .navigationTitle("Entries")
//        .animation(.spring(response: 1, dampingFraction: 1), value: 1)
        .listStyle(SidebarListStyle())
        .overlay(commit.loading ? showLoading : nil, alignment: .bottom)
    }
}
