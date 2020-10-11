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
    var addUrl: () -> Void
    
    @State private var selection: RepositoryModel?
    @EnvironmentObject private var model: ScourModel
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Group {
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
    //        .overlay(addRepositoryButton, alignment: .bottom)
            .navigationTitle("Repositories")
            .animation(.spring(response: 1, dampingFraction: 1), value: 1)
            
            AddRepositoryButton(action: addUrl)
        }
    }
}

//struct RepositoryList_Previews: PreviewProvider {
//    var repositories: [RepositoryModel]
//    static var previews: some View {
//        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
//            NavigationView {
//                RepositoryList(repositories: self.repositories)
//                    .navigationTitle("Repositories")
//                    .environmentObject(ScourModel())
//            }
//            .preferredColorScheme(scheme)
//        }
//    }
//}
