//
//  AppSidebarNavigation.swift
//  Scour
//
//  Created by Paul Thrasher on 9/26/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

struct AppSidebarNavigation: View {

    enum NavigationItem {
        case repo
        case branch
        case commit
        case tree
    }

    @EnvironmentObject private var model: ScourModel
    @State private var selection: Set<NavigationItem> = [.repo]
    @State private var presentingRewards = false
    
    var sidebar: some View {
        List(selection: $selection) {
            NavigationLink(destination: RepositoryMenu(model: model)) {
                Label("Repository", systemImage: "cylinder.split.1x2")
            }
            .accessibility(label: Text("Repository"))
            .tag(NavigationItem.repo)
            
//            NavigationLink(destination: BranchMenu()) {
//                Label("Branch", systemImage: "heart")
//            }
//            .accessibility(label: Text("Branch"))
//            .tag(NavigationItem.branch)
//
//            NavigationLink(destination: CommitMenu()) {
//                Label("Commit", systemImage: "book.closed")
//            }
//            .accessibility(label: Text("Commit"))
//            .tag(NavigationItem.commit)
//
//            NavigationLink(destination: TreeMenu()) {
//                Label("Tree", systemImage: "book.closed")
//            }
//            .accessibility(label: Text("Tree"))
//            .tag(NavigationItem.tree)
        }
        .listStyle(SidebarListStyle())
    }
    
    var body: some View {
        NavigationView {
            sidebar
            
            Text("Content List")
            
            Text("Select a Repository")
        }
    }
    
}

struct AppSidebarNavigation_Previews: PreviewProvider {
    static var previews: some View {
        AppSidebarNavigation()
            .environmentObject(ScourModel())
    }
}
