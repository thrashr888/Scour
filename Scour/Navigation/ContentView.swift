//
//  ContentView.swift
//  Scour
//
//  Created by Paul Thrasher on 6/14/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import Carbon.HIToolbox.Events
import SwiftGit2
import SwiftUI

struct RepoListView: View {
    var repo: RepositoryModel
    var body: some View {
        NavigationView {
            List(repo.branches) { branch in
                Text(branch.id)
//                NavigationLink(destination: RepoListView(repo: repo)) {
//                    Text(repo.name ?? "repo not found")
//                }
            }
//            .listStyle(SidebarListStyle())
            .navigationTitle(Text("Branch"))
//            .navigationBarItems(leading:
//                HStack {
//                    Button("Hours") {
//                        print("Hours tapped!")
//                    }
//                }, trailing:
//                HStack {
//                    Button("Favorites") {
//                        print("Favorites tapped!")
//                    }
//
//                    Button("Specials") {
//                        print("Specials tapped!")
//                    }
//                }
//            )
        }
    }
}

struct ContentView: View {
    @ObservedObject var store: ScourModel
    @ObservedObject var commitsModel: CommitsModel

    @State var entry: Tree.Entry? = nil
    
    init(store: ScourModel, commitsModel: CommitsModel) {
        self.store = store
        self.commitsModel = commitsModel
    }

    func prevCommit() {
        commitsModel.prevCommit()
    }

    func nextCommit() {
        commitsModel.nextCommit()
    }

    // TODO switch to use new .commands API
//    .commands {
//        CommandMenu("Shapes") {
//            Button("Add Shape...", action: addShape)
//                .keyboardShortcut("N")
//            Button("Add Text", action: addText)
//                .keyboardShortcut("T")
//        }
//    }
    func onKeyEvent(event: NSEvent) {
        if event.keyCode == kVK_LeftArrow || event.keyCode == kVK_ANSI_Comma {
            commitsModel.prevCommit()
        } else
        if event.keyCode == kVK_RightArrow || event.keyCode == kVK_ANSI_Period {
            commitsModel.nextCommit()
        }
    }

    var body: some View {
        AppSidebarNavigation()
//        NavigationView {
//            
////            NavigationLink(destination: Text("Second View")) {
////                Text("Hello, World!")
////            }.navigationTitle("first")
//            
//            List(store.repositories) { repo in
//                NavigationLink(destination: RepoListView(repo: repo)) {
//                    Text(repo.name ?? "repo not found")
//                }
//            }
//            .listStyle(SidebarListStyle())
//            .navigationTitle("Repository")
//        }
    
//        HStack {
////            NavigationView {
////                FinderView(entry: $entry, commitsModel: commitsModel)
////                    .frame(minWidth: 200, maxWidth: 300, minHeight: 300, maxHeight: .infinity)
////                    .padding(.trailing)
////            }
//
//            VStack {
//                Text("entry")
////                CommitSummaryView(commitsModel: commitsModel)
//
////                if commitsModel.commit != nil {
////                    HStack {
////                        CommitsLineView(entry: $entry, commitsModel: commitsModel)
////                        Button("<", action: prevCommit)
////                        Button(">", action: nextCommit)
////                    }
////                    .padding(.top, 8.0)
////                    .padding(.trailing, 5.0)
////
////                    CommitSelectSingleView(commit: commitsModel.commit!)
////                        .padding(.trailing, 5.0)
////                        .background(KeyEventHandler(callback: onKeyEvent))
////
////                    Divider()
////                }
////
////                if commitsModel.repoUrl != nil && commitsModel.entry != nil {
////                    NewEntryView(commitsModel: commitsModel, entry: commitsModel.entry!)
////                        .frame(minWidth: 300, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
////                } else {
////                    Text(" ")
////                        .frame(minWidth: 300, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
////                }
//            }
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: ScourModel(), commitsModel: CommitsModel())
    }
}
