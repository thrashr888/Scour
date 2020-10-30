//
//  BranchMenu.swift
//  Scour
//
//  Created by Paul Thrasher on 10/3/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

struct BranchMenu: View {
    @ObservedObject var model: RepositoryModel
    
    var body: some View {
        if model.error != nil {
            ErrorView(error: model.error!)
        }
        BranchList(repository: model, branches: model.branches)
            .navigationTitle("Branches")
            .onAppear {
                DispatchQueue.main.async {
                    model.load()
                }
            }
            .toolbar {
                Button(action: {
                    model.fetch()
                }) {
                    Label("Fetch", systemImage: "arrow.clockwise")
                }
            }
    }
    
}
