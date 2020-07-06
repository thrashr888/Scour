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
    
    init(_ repo: Repository) {
        self.repo = repo
        
        let res = repo.localBranches()

        switch res {
        case let .success(obj):
            self.branches = obj
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
                Text("Branches").bold()
                List(branches!, id: \.hashValue) { branch in
                    BranchView(repo: self.repo, branch: branch)
                }
            }
        }
    }
}

//struct RepoView_Previews: PreviewProvider {
//    static var previews: some View {
//        RepoView()
//    }
//}
