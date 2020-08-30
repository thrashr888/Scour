//
//  FinderView.swift
//  Scour
//
//  Created by Paul Thrasher on 8/12/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import Clibgit2
import SwiftGit2
import SwiftUI

struct FinderView: View {
    @Binding var entry: Tree.Entry?

    @ObservedObject var commitsModel: CommitsModel

    func clearRepo() { commitsModel.repoUrl = nil }
    func clearBranch() { commitsModel.branch = nil }
    func clearCommit() { commitsModel.commit = nil }
    func fetch() {
        if commitsModel.fetch() == nil {
            // no errors
            commitsModel.loadCommits()
        }
    }

    var body: some View {
        VStack {
            if commitsModel.repoUrl == nil {
                FolderSelectView(currentUrl: $commitsModel.repoUrl)
            } else if commitsModel.repoUrl != nil && commitsModel.branch == nil {
                HStack {
                    Button("<", action: clearRepo)
                    Text("Repo")
                    Text(commitsModel.repoUrl!.path)
                        .frame(height: 13.0)
                        .truncationMode(.head)
                    Spacer()
                }
                .padding(.top)
                .padding(.leading, 5.0)

                BranchSelectView(repoUrl: commitsModel.repoUrl!, currentBranch: $commitsModel.branch)
            } else if commitsModel.repoUrl != nil && commitsModel.branch != nil && commitsModel.commit == nil {
                HStack {
                    Button("<", action: clearBranch)
                    Text("Branch \(commitsModel.branch!.name)")
                    Spacer()
                    Button("fetch", action: fetch)
                }
                .padding(.top)
                .padding(.leading, 5.0)

                CommitSelectView(repoUrl: commitsModel.repoUrl!, branch: commitsModel.branch!, commits: $commitsModel.commits, currentCommit: $commitsModel.commit)
            } else if commitsModel.repoUrl != nil && commitsModel.branch != nil && commitsModel.commit != nil {
                HStack {
                    Button("<", action: clearCommit)
                    VStack {
                        HStack {
                            Text("Commit")
                            Text(commitsModel.commit!.tree.oid.description)
                                .frame(height: 13.0)
                                .truncationMode(.tail)
                            Spacer()
                        }
                    }
                }
                .padding(.top)
                .padding(.leading, 5.0)

                TreeSelectView(repoUrl: commitsModel.repoUrl!, commit: commitsModel.commit!, currentEntry: $entry)
            }
        }
    }
}

struct FinderView_Previews: PreviewProvider {
    static var previews: some View {
        FinderView(
            entry: .constant(nil),
            commitsModel: CommitsModel()
        )
    }
}
