//
//  FinderView.swift
//  Scour
//
//  Created by Paul Thrasher on 8/12/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI
import SwiftGit2
import Clibgit2

struct FinderView: View {
    @Binding var repoUrl: URL?
    @Binding var branch: Branch?
    @Binding var commits: [Commit]
    @Binding var commit: Commit?
    @Binding var entry: Tree.Entry?
    
    func clearRepo() { self.repoUrl = nil }
    func clearBranch() { self.branch = nil }
    func clearCommit() { self.commit = nil }
    
    var body: some View {
        VStack {
            if repoUrl == nil {
                FolderSelectView(currentUrl: self.$repoUrl)
            } else if repoUrl != nil && branch == nil {
                HStack {
                    Button("<", action: clearRepo)
                    Text("Repo")
                    Text(repoUrl!.path).frame(height: 13.0).truncationMode(.head)
                    Spacer()
                }.padding(.top).padding(.leading, 5.0)
                BranchSelectView(repoUrl: repoUrl!, currentBranch: $branch)
            } else if repoUrl != nil && branch != nil && commit == nil {
                HStack {
                    Button("<", action: clearBranch)
                    Text("Branch \(branch!.name)")
                    Spacer()
                }.padding(.top).padding(.leading, 5.0)
                CommitSelectView(repoUrl: repoUrl!, branch: branch!, commits: $commits, currentCommit: $commit)
            } else if repoUrl != nil && branch != nil && commit != nil {
                HStack {
                    Button("<", action: clearCommit)
                    VStack {
                        HStack {
                            Text("Commit")
                            Text(commit!.tree.oid.description).frame(height: 13.0).truncationMode(.tail)
                            Spacer()
                        }
                    }
                }.padding(.top).padding(.leading, 5.0)
                TreeSelectView(repoUrl: repoUrl!, commit: commit!, currentEntry: $entry)
            }
        }
    }
}

struct FinderView_Previews: PreviewProvider {
    static var previews: some View {
        FinderView(
            repoUrl: .constant(nil),
            branch: .constant(nil),
            commits: .constant([]),
            commit: .constant(nil),
            entry: .constant(nil)
        )
    }
}
