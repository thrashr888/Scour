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
    var commits: [Commit] = []
    @State var tree: Tree?
    @State var currentEntry: Tree.Entry?
    @State var currentCommit: Commit?
    
    init(repo: Repository, branch: Branch) {
        self.repo = repo
        self.branch = branch
        
        switch repo.commit(branch.commit.oid) {
        case let .success(obj):
            commit = obj
        case let .failure(error):
            self.error = error
        }
        
        self.commits = repo.commits(in: branch).compactMap({commit in
            switch commit {
            case let .success(obj):
                return obj
            case let .failure(error):
                self.error = error
                return nil
            }
        })
        
        if self.commit != nil {

            switch repo.tree(commit!.tree.oid) {
            case let .success(obj):
                self.tree = obj
                let firstKey = obj.entries.keys.sorted()[0]
                currentEntry = obj.entries[firstKey]
            case let .failure(error):
                self.error = error
            }
            
//            self.tree = self.getTree(commit: commit!)
//            guard let tree = self.getTree(commit: commit!) else { return }
//            self.tree = tree
//            let firstKey = tree.entries.keys.sorted()[0]
//            currentEntry = tree.entries[firstKey]
        }
//        switch repo.tree(oid) {
//        case let .success(obj):
//            tree = obj
//            let firstKey = obj.entries.keys.sorted()[0]
//            currentEntry = obj.entries[firstKey]
//        case let .failure(error):
//            self.error = error
//        }
    }
    
//    mutating func getTree(commit: Commit) -> Tree?{
//        switch repo.tree(commit.tree.oid) {
//        case let .success(obj):
//            return obj
//        case .failure(_):
//            return nil
//        }
//    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if error != nil {
                ErrorView(error: error!)
            }
            
            if commit != nil{
                CommitView(commit: commit!)
            }
            if currentCommit != nil{
                CommitView(commit: currentCommit!)
            }
            
            HStack(alignment: .top) {
                ScrollView([.vertical]) {
                    VStack(alignment: .leading) {
                        ForEach(commits.indices) { i in

                            Button(action: {

                                switch self.repo.tree(self.commits[i].tree.oid) {
                                case let .success(obj):
                                    self.tree = obj
                                    let firstKey = obj.entries.keys.sorted()[0]
                                    self.currentEntry = obj.entries[firstKey]
                                case let .failure(error):
                                    self.error = error
                                }
                                
                            }) {
                                Text("\(self.commits[i].oid.description.suffix(6).description) \(self.commits[i].message)").padding(.bottom, 3.0).truncationMode(.tail).lineLimit(/*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/).padding(.vertical, 2.0)
                            }.buttonStyle(PlainButtonStyle())
                            
                        }
                    }.padding()
                }
                .frame(width: 250)
                .background(Color(.sRGB, white: 0.1, opacity: 1))
                
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
