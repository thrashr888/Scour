//
//  CommitList.swift
//  Scour
//
//  Created by Paul Thrasher on 10/6/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

struct CommitList: View {
    var branch: BranchModel
    var commits: [CommitModel]
    
    @State private var selection: CommitModel?
    @EnvironmentObject private var model: ScourModel
    
    var showLoading: some View {
        ProgressView().padding()
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            List(selection: $selection) {
                ForEach(commits) { commit in
                    NavigationLink(
                        destination: EntryMenu(model: commit).environmentObject(model),
                        tag: commit,
                        selection: $selection
                    ) {
                        CommitRow(commit: commit)
                    }
                    .tag(commit)
                }
                
                if branch.more && !branch.loading {
                    Button(action: {
//                        DispatchQueue.main.async {
                            branch.load()
                            proxy.scrollTo(commits.count, anchor: .bottom)
//                        }
                    }) {
                        Text("Load more")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(VisualEffectBlur().edgesIgnoringSafeArea(.all))
//                            .background(Color.accentColor)
                    }.buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Commits")
//            .animation(.spring(response: 1, dampingFraction: 1), value: 1)
    //        .listStyle(SidebarListStyle())
            .overlay(branch.loading ? showLoading : nil, alignment: .bottom)
        }
    }
}
