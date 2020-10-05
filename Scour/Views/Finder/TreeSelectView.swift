//
//  TreeSelectView.swift
//  Scour
//
//  Created by Paul Thrasher on 8/13/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import Clibgit2
import SwiftGit2
import SwiftUI

struct TreeSelectView: View {
    @ObservedObject var commitsModel: CommitsModel

    func loadTree() {
        commitsModel.loadTree(commitsModel.commit!)
    }

    var body: some View {
        // TODO: use an "outline" list here
        //       List(entries, children: \.children) { e in
        List(commitsModel.entries.sorted { $0.name < $1.name }, id: \.self, selection: $commitsModel.entry) { entry in
            if entry.attributes == Int32(GIT_FILEMODE_TREE.rawValue) {
                Text("􀄧 \(entry.name)").tag(entry)
            } else {
                Text(entry.name).tag(entry)
            }
        }
        .listStyle(SidebarListStyle())
        .onAppear(perform: loadTree)
    }
}

// struct TreeSelectView_Previews: PreviewProvider {
//    static var previews: some View {
//        TreeSelectView()
//    }
// }
