//
//  TreeView.swift
//  Scour
//
//  Created by Paul Thrasher on 7/5/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI
import SwiftGit2
import Clibgit2

struct TreeView: View {
    var repo: Repository
    var tree: Tree
    var parent: Tree.Entry?
    @Binding var currentEntry: Tree.Entry?
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(tree.entries.keys.sorted(), id: \.self) { key in
                Group {
//                    EntryView(repo: self.repo, entry: self.tree.entries[key]!, parent: self.parent)

                    if self.tree.entries[key]!.attributes == Int32(GIT_FILEMODE_TREE.rawValue) {
                        HStack {
                            Text("􀄧 \(self.tree.entries[key]!.name)")
                        }
                    }

                    if self.tree.entries[key]!.attributes == Int32(GIT_FILEMODE_BLOB.rawValue) {

                        Button(action: {
                            self.currentEntry = self.tree.entries[key]!
                        }) {
                            Text("\(self.tree.entries[key]!.name)")
                        }.buttonStyle(PlainButtonStyle()).padding(.vertical, 2.0)
                    }
                }
            }
        }
    }
}

//struct TreeView_Previews: PreviewProvider {
//    static var previews: some View {
//        TreeView()
//    }
//}
