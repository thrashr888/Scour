//
//  CommitList.swift
//  Scour
//
//  Created by Paul Thrasher on 10/6/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

struct CommitList: View {
    var commits: [CommitModel]
    
    @State private var selection: CommitModel?
    @EnvironmentObject private var model: ScourModel
    
    var body: some View {
        List(selection: $selection) {
            ForEach(commits) { commit in
                NavigationLink(
                    destination: EntryMenu(model: commit).environmentObject(model),
                    tag: commit,
                    selection: $selection
                ) {
                    CommitRow(commit: commit)
                }
                .tag(commit)
            }
        }
    }
}
