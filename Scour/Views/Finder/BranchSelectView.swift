//
//  BranchSelectView.swift
//  Scour
//
//  Created by Paul Thrasher on 8/13/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI
import SwiftGit2
import Clibgit2

struct BranchSelectView: View {
    // input
    var repoUrl: URL

    // internal
    @State var branches: [Branch] = []

    // bound
    @Binding var currentBranch: Branch?
    
    func loadBranches() {
        switch Repository.at(self.repoUrl) {
        case let .success(repo):
            switch repo.localBranches() {
            case let .success(obj):
                self.branches = obj
//                for (_, branch) in obj.enumerated() {
//                    if branch.name == "master" {
//                        self.currentBranch = branch
//                    }
//                }
            case .failure(_):
                return
            }
        case .failure(_):
            return
        }
    }
    
    var body: some View {
        List(self.branches, id: \.self, selection: $currentBranch) { branch in
            Text(branch.name).tag(branch)
        }.onAppear(perform: loadBranches)
    }
}

//struct BranchSelectView_Previews: PreviewProvider {
//    static var previews: some View {
//        BranchSelectView()
//    }
//}
