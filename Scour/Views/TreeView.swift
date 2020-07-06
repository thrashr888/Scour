//
//  TreeView.swift
//  Scour
//
//  Created by Paul Thrasher on 7/5/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI
import SwiftGit2

struct TreeView: View {
    var repo: Repository
    var tree: Tree

    var body: some View {
        VStack(alignment: .leading) {
            Text("Tree: \(tree.oid.description)")
            ForEach(tree.entries.keys.sorted(), id: \.self) { key in
                EntryView(repo: self.repo, entry: self.tree.entries[key]!)
            }
        }
    }
}

//struct TreeView_Previews: PreviewProvider {
//    static var previews: some View {
//        TreeView()
//    }
//}
