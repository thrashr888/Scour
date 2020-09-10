//
//  TreeView.swift
//  Scour
//
//  Created by Paul Thrasher on 7/5/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftGit2
import SwiftUI
import Clibgit2

struct TreeView: View {
    var repo: Repository
    var tree: Tree
    var parent: Tree.Entry?
    @Binding var currentEntry: Tree.Entry?

    private var dirs: [Tree.Entry] = []
    private var files: [Tree.Entry] = []

    init(repo: Repository, tree: Tree, parent: Tree.Entry? = nil, currentEntry: Binding<Tree.Entry?>) {
        self.repo = repo
        self.tree = tree
        self.parent = parent
        _currentEntry = currentEntry

        for entry in tree.entries {
            if entry.value.attributes == Int32(GIT_FILEMODE_TREE.rawValue) {
                dirs.append(entry.value)
            } else if entry.value.attributes == Int32(GIT_FILEMODE_BLOB.rawValue) {
                files.append(entry.value)
//                if entry.value.name.hasSuffix(".md") || entry.value.name.hasSuffix(".markdown") {
//                    files.append(entry.value)
//                }
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            List(dirs, id: \.self) { entry in
                Text("􀄧 \(entry.name)")
            }
            List(files, id: \.self) { entry in
                Button(action: {
                    self.currentEntry = entry
                }) {
                    Text("\(entry.name)")
                }.buttonStyle(PlainButtonStyle()).padding(.vertical, 2.0)
            }

//            ForEach(tree.entries.keys.sorted(), id: \.self) { key in
//                Group {
            ////                    EntryView(repo: self.repo, entry: self.tree.entries[key]!, parent: self.parent)
//
//                    if self.tree.entries[key]!.attributes == Int32(GIT_FILEMODE_TREE.rawValue) {
//                        HStack {
//                            Text("􀄧 \(self.tree.entries[key]!.name)")
//                        }
//                    }
//
//                    if self.tree.entries[key]!.attributes == Int32(GIT_FILEMODE_BLOB.rawValue) {
//
//                        Button(action: {
//                            self.currentEntry = self.tree.entries[key]!
//                        }) {
//                            Text("\(self.tree.entries[key]!.name)")
//                        }.buttonStyle(PlainButtonStyle()).padding(.vertical, 2.0)
//                    }
//                }
//            }
        }
    }
}

// struct TreeView_Previews: PreviewProvider {
//    static var previews: some View {
//        TreeView()
//    }
// }
