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
    // input
    var repoUrl: URL

    // internal
    @State var branches: [Branch] = []

    // bound
    @Binding var currentBranch: Branch?

    func loadBranches() {
        switch Repository.at(repoUrl) {
        case let .success(repo):
            switch repo.localBranches() {
            case let .success(obj):
                branches = obj
//                for (_, branch) in obj.enumerated() {
//                    if branch.name == "master" {
//                        self.currentBranch = branch
//                    }
//                }
            case .failure:
                return
            }
        case .failure:
            return
        }
    }

    var body: some View {
        List(self.branches, id: \.self, selection: $currentBranch) { branch in
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
