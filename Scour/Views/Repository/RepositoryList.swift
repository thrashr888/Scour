//
//  RepoList.swift
//  Scour
//
//  Created by Paul Thrasher on 9/27/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

struct RepositoryList: View {
    var scour: ScourModel
    var repositories: [RepositoryModel]
    var addUrl: () -> Void
    
    @State private var selection: RepositoryModel?
    @EnvironmentObject private var model: ScourModel
    @Environment(\.colorScheme) private var colorScheme
    
    var showLoading: some View {
        ProgressView().padding()
    }
    
    var body: some View {
        List(selection: $selection) {
            ForEach(repositories.sorted { $0.name < $1.name }) { repository in
                NavigationLink(
                    destination: BranchMenu(model: repository).environmentObject(model),
                    tag: repository,
                    selection: $selection
                ) {
                    RepositoryRow(repository: repository)
                }
                .tag(repository)
            }
        }
        .navigationTitle("Repositories")
//        .animation(.spring(response: 1, dampingFraction: 1), value: 1)
//        .listStyle(SidebarListStyle())
        .overlay(scour.loading ? showLoading : nil, alignment: .bottom)
    }
}
