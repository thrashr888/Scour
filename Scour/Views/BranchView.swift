//
//  BranchView.swift
//  Scour
//
//  Created by Paul Thrasher on 7/5/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI
import SwiftGit2
import Clibgit2

struct BranchView: View {
    @State var error: Error?
    var repo: Repository
    var branch: Branch
    var commit: Commit?
    var tree: Tree?
    @State var currentEntry: Tree.Entry?
    
    init(repo: Repository, branch: Branch) {
        self.repo = repo
        self.branch = branch
        
        switch repo.commit(branch.commit.oid) {
        case let .success(obj):
            self.commit = obj
        case let .failure(error):
            self.error = error
        }
        
        guard let oid = self.commit?.tree.oid else { return }
        switch repo.tree(oid) {
        case let .success(obj):
            self.tree = obj
            let firstKey = obj.entries.keys.sorted()[0]
            self.currentEntry = obj.entries[firstKey]
        case let .failure(error):
            self.error = error
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if error != nil {
                ErrorView(error: error!)
            }

            if commit != nil{
                CommitView(commit: commit!)
            }
            
            HStack(alignment: .top) {
                if tree != nil {
                    ScrollView([.vertical]) {
                        TreeView(repo: repo, tree: tree!, currentEntry: self.$currentEntry)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                    }
                    .frame(width: 250)
                    .background(Color(.sRGB, white: 0.1, opacity: 1))
                }
                if currentEntry != nil {
//                    Text("Current Entry")
                    ScrollView([.vertical]) {
                        EntryView(repo: repo, entry: currentEntry!, parent: nil, showContent: true)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                    }
                }
            }
        }
    }
}

//struct BranchView_Previews: PreviewProvider {
//    static var previews: some View {
//        BranchView()
//    }
//}
