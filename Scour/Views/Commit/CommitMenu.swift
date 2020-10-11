//
//  CommitMenu.swift
//  Scour
//
//  Created by Paul Thrasher on 10/6/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

struct CommitMenu: View {
    @ObservedObject var model: BranchModel
    
    var body: some View {
        CommitList(commits: model.commits)
            .navigationTitle("Commits")
            .onAppear {
                model.load()
            }
    }
    
}
