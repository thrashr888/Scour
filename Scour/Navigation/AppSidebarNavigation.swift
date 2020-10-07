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
                Label("Repositories", systemImage: "book.closed")
            }
            .accessibility(label: Text("Repositories"))
            .tag(NavigationItem.repo)
        }
        .listStyle(SidebarListStyle())
    }
    
    var body: some View {
        NavigationView {
            sidebar
            
            Text("Content List")
            
            Text("Select a Repository")
            
            Text("Select a Branch")
            
            Text("Select a Commit")
            
            Text("Select an Entry")
        }
    }
    
}

struct AppSidebarNavigation_Previews: PreviewProvider {
    static var previews: some View {
        AppSidebarNavigation()
            .environmentObject(ScourModel())
    }
}
