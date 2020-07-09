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
        case let .failure(error):
            self.error = error
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if error != nil {
                ErrorView(error: error!)
            }

            if commit != nil{
                CommitView(commit: commit!)
            }
            
            if tree != nil {
                TreeView(repo: repo, tree: tree!)
            }
            
            if currentEntry != nil {
                Text("Current Entry")
                EntryView(repo: repo, entry: currentEntry!, parent: nil, showContent: true)
            }
        }.onPreferenceChange(CurrentEntryPreferenceKey.self) { res in
            print("changed key \(String(describing: res))")
            guard let entry = res?.entry else { return }
            
            print("found \(entry.name)")

            self.currentEntry = entry
            
        }
    }
}

//struct BranchView_Previews: PreviewProvider {
//    static var previews: some View {
//        BranchView()
//    }
//}
