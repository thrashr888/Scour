//
//  BranchList.swift
//  Scour
//
//  Created by Paul Thrasher on 10/3/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

struct BranchList: View {
    var repository: RepositoryModel
    var branches: [BranchModel]
    
    @State private var selection: BranchModel?
    @EnvironmentObject private var model: ScourModel
    
    var showLoading: some View {
        ProgressView().padding()
    }
    
    var body: some View {
        List(selection: $selection) {
            ForEach(branches.sorted { $0.name < $1.name }) { branch in
                NavigationLink(
                    destination: CommitMenu(model: branch).environmentObject(model),
                    tag: branch,
                    selection: $selection
                ) {
                    BranchRow(branch: branch)
                }
                .tag(branch)
            }
        }
        .navigationTitle("Branches")
//        .animation(.spring(response: 1, dampingFraction: 1), value: 1)
//        .listStyle(SidebarListStyle())
        .overlay(repository.loading ? showLoading : nil, alignment: .bottom)
    }
}
