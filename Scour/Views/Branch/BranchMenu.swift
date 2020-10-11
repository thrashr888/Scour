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
        BranchList(branches: model.branches)
            .navigationTitle("Branches")
            .onAppear {
                model.load()
            }
    }
    
}
