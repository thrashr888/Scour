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
        if model.error != nil {
            ErrorView(error: model.error!)
        }
        CommitList(branch: model, commits: model.commits)
            .navigationTitle("Commits")
            .onAppear {
                DispatchQueue.main.async {
                    model.load()
                }
            }
    }
    
}
