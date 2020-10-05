//
//  RepoList.swift
//  Scour
//
//  Created by Paul Thrasher on 9/27/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

struct RepositoryList: View {
    var repositories: [RepositoryModel]
    
    @State private var selection: RepositoryModel?
    @EnvironmentObject private var model: ScourModel
    
    var body: some View {
        List(selection: $selection) {
            ForEach(repositories) { repository in
                NavigationLink(
                    destination: BranchMenu(model: repository).environmentObject(model),
                    tag: repository,
                    selection: $selection
                ) {
                    RepositoryRow(repository: repository)
                }
                .tag(repository)
//                .onReceive($model.selectedRepositoryID) { newValue in
//                    guard let repository = model.selectedRepository else { return }
//                    selection = repository
//                }
            }
        }
    }
}

//struct RepoList_Previews: PreviewProvider {
//    static var previews: some View {
//        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
//            NavigationView {
//                RepoList(smoothies: Repository.all)
//                    .navigationTitle("Repositories")
//                    .environmentObject(ScourModel())
//            }
//            .preferredColorScheme(scheme)
//        }
//    }
//}
