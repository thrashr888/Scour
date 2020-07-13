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

struct CommitName: View {
    var commit: Commit
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    var body: some View {
        HStack(alignment: .top) {
            Text(commit.oid.description.suffix(6).description)
                .foregroundColor(Color.gray)
            Text(commit.message).truncationMode(.tail).lineLimit(/*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/).frame(maxWidth: .infinity, alignment: .leading)
            Text("\(commit.committer.time, formatter: Self.taskDateFormat)").foregroundColor(Color.gray).multilineTextAlignment(.trailing)
        }
    }
}

struct BranchView: View {
    @State var error: Error?
    var repo: Repository
    var branch: Branch
    var commits: [Commit] = []
    @State var tree: Tree?
    @State var currentEntry: Tree.Entry?
    @State var currentCommit: Commit?
    @State var loading: Bool = false
    
    init(repo: Repository, branch: Branch) {
        self.repo = repo
        self.branch = branch
        
        self.commits = repo.commits(in: branch).compactMap({commit in
            switch commit {
            case let .success(obj):
                return obj
            case let .failure(error):
                self.error = error
                return nil
            }
        })
    }
    
    func isCurrentCommit(commit: Commit) -> Bool {
        return self.currentCommit != nil && commit.oid.description == self.currentCommit!.oid.description
    }
    
    func loadTree(commit: Commit) {
        switch self.repo.tree(commit.tree.oid) {
        case let .success(obj):
            self.tree = obj
            if self.currentEntry != nil {
                self.currentEntry = obj.entries[self.currentEntry!.name]
            } else {
                let firstKey = obj.entries.keys.sorted()[0]
                self.currentEntry = obj.entries[firstKey]!
            }
        case let .failure(error):
            self.error = error
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if error != nil {
                ErrorView(error: error!)
            }
            
            if currentCommit != nil{
                CommitView(commit: currentCommit!)
            }
            
            HStack(alignment: .top) {
                ScrollView([.vertical]) {
                    VStack(alignment: .leading) {
                        ForEach(commits.indices) { i in

                            Button(action: {
                                if self.loading { return }
                                self.currentCommit = self.commits[i]
                                self.loadTree(commit: self.commits[i])
                                self.loading = false
                            }) {
                                if self.isCurrentCommit(commit: self.commits[i]) {
                                    CommitName(commit: self.commits[i]).font(Font.body.bold())
                                } else {
                                    CommitName(commit: self.commits[i])
                                }
                            }.buttonStyle(PlainButtonStyle()).onHover { hovering in
                                if self.loading { return }
                                self.currentCommit = self.commits[i]
                                self.loadTree(commit: self.commits[i])
                                self.loading = false
                            }
                            
                        }
                    }.padding()
                }
                .frame(width: 300)
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
