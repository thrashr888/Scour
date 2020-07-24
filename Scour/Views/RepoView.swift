//
//  RepoView.swift
//  Scour
//
//  Created by Paul Thrasher on 7/5/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI
import SwiftGit2

struct RepoView: View {
    var error: Error?
    var repo: Repository
    var branches: [Branch]?
    @State var currentBranch = 0
    
    init(_ repo: Repository) {
        self.repo = repo
        
        switch repo.localBranches() {
        case let .success(obj):
            self.branches = obj
            for (i, branch) in obj.enumerated() {
                if branch.name == "master" {
                    _currentBranch = State(initialValue: i)
                }
            }
        case let .failure(error):
            self.error = error
        }
    }
    
    var body: some View {
        VStack {
            if self.error != nil {
                ErrorView(error: self.error!)
            }
            if branches != nil {
                Picker("Branch", selection: $currentBranch) {
                    ForEach(branches!.indices, id: \.self) { i in
                        Text("\(self.branches![i].name)").tag(i)
                    }
                }
                .padding(.horizontal).padding([.bottom], 2)

                BranchView(repo: self.repo, branch: branches![self.currentBranch])
            }
        }
    }
}

//struct RepoView_Previews: PreviewProvider {
//    static var previews: some View {
//        RepoView()
//    }
//}
