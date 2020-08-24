//
//  CommitSelectView.swift
//  Scour
//
//  Created by Paul Thrasher on 8/13/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI
import SwiftGit2
import Clibgit2

struct CommitSelectSingleView: View {
    var commit: Commit
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .lastTextBaseline) {
                Text(commit.author.name)
                    .foregroundColor(Color.orange).truncationMode(.tail)
                Text("\(commit.committer.time, formatter: Self.taskDateFormat)").multilineTextAlignment(.trailing)
                Spacer()
                Text(commit.oid.description).frame(width: 60.0, height: 13.0).truncationMode(.tail)
            }
            HStack {
                Text(commit.message).frame(height: 13.0).truncationMode(.tail)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
    }
}

struct CommitSelectView: View {
    // input
    var repoUrl: URL
    var branch: Branch
    
    // internal
    @Binding var commits: [Commit]
    
    // bound
    @Binding var currentCommit: Commit?
    
    func loadCommits() {
        switch Repository.at(self.repoUrl) {
        case let .success(repo):
            for commit in repo.commits(in: self.branch) {
                switch commit {
                case nil:
                    return
                case let .success(obj):
                    self.commits.append(obj)
//                    if self.currentCommit == nil {
//                        self.currentCommit = obj
//                    }
                case .failure(_):
                    return
                }
            }
        case .failure(_):
            return
        }
    }
    
    var body: some View {
        List(self.commits, id: \.self, selection: $currentCommit) { commit in
            CommitSelectSingleView(commit: commit).tag(commit)
//            Text("● \(commit.message)").tag(commit)
        }.onAppear(perform: loadCommits).padding(.vertical, 1).padding(.horizontal, 3)
    }
}

//struct CommitSelectView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommitSelectView()
//    }
//}
