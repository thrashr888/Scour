//
//  BranchSelectView.swift
//  Scour
//
//  Created by Paul Thrasher on 8/13/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import Clibgit2
import SwiftGit2
import SwiftUI

struct BranchSelectView: View {
    @ObservedObject var commitsModel: CommitsModel

    func loadBranches() {
        commitsModel.loadBranches()
    }

    var body: some View {
        List(commitsModel.branches, id: \.self, selection: $commitsModel.branch) { branch in
            Text(branch.name).tag(branch)
        }
        .onAppear(perform: loadBranches)
    }
}

// struct BranchSelectView_Previews: PreviewProvider {
//    static var previews: some View {
//        BranchSelectView()
//    }
// }
