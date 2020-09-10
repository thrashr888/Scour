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

extension AnyTransition {
    static var customTransition: AnyTransition {
      let insertion = AnyTransition.move(edge: .trailing)
        .combined(with: .scale(scale: 0.2, anchor: .trailing))
        .combined(with: .opacity)
      let removal = AnyTransition.move(edge: .leading)
      return .asymmetric(insertion: insertion, removal: removal)
    }
}

// just adds an HStack with some padding
struct SelectTitleView<Content: View>: View {
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        HStack {
            self.content()
        }
        .padding(.top)
        .padding(.leading, 5.0)
    }
}

struct FinderView: View {
    @Binding var entry: Tree.Entry?

    @ObservedObject var commitsModel: CommitsModel

    func clearRepo() { commitsModel.repoUrl = nil }
    func clearBranch() { commitsModel.branch = nil }
    func clearCommit() { commitsModel.commit = nil }
    func fetch() {
        if commitsModel.fetch() == nil {
            // no errors
            commitsModel.loadNextCommits()
        }
    }

    var body: some View {
        VStack {
            if commitsModel.repoUrl == nil {
                
                VStack {
                    FolderSelectView(currentUrl: $commitsModel.repoUrl)
                }.animation(.easeInOut).transition(.slide)
                
            } else if commitsModel.repoUrl != nil && commitsModel.branch == nil {
                
                VStack {
                    SelectTitleView {
                        Button("<", action: self.clearRepo)
                        Text(self.commitsModel.repoName!)
                            .frame(height: 13.0)
                            .truncationMode(.head)
                        Text("repo")
                            .foregroundColor(Color.gray)
                        Spacer()
                    }

                    BranchSelectView(commitsModel: commitsModel)
                }.animation(.easeInOut).transition(.slide)

            } else if commitsModel.repoUrl != nil && commitsModel.branch != nil && commitsModel.commit == nil {
                
                VStack {
                    SelectTitleView {
                        Button("<", action: self.clearBranch)
                        Text("\(self.commitsModel.branch!.name)")
                            .truncationMode(.tail)
                        Text("branch")
                            .foregroundColor(Color.gray)
                        Spacer()
                        Button("fetch", action: self.fetch)
                    }

                    CommitSelectView(commitsModel: commitsModel)
                }.animation(.easeInOut).transition(.slide)
                
            } else if commitsModel.repoUrl != nil && commitsModel.branch != nil && commitsModel.commit != nil {
                
                VStack {
                    SelectTitleView {
                        Button("<", action: self.clearCommit)
                        VStack {
                            HStack {
                                Text(self.commitsModel.commit!.tree.oid.description)
                                    .frame(height: 13.0)
                                    .truncationMode(.tail)
                                Text("commit")
                                    .foregroundColor(Color.gray)
                                Spacer()
                            }
                        }
                    }

                    TreeSelectView(commitsModel: commitsModel)

                }.animation(.easeInOut).transition(.slide)
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
