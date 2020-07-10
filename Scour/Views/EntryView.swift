//
//  EntryView.swift
//  Scour
//
//  Created by Paul Thrasher on 7/5/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI
import SwiftGit2
import Clibgit2

var filemodesByFlag = [
    Int32(GIT_FILEMODE_UNREADABLE.rawValue): "unreadable",
    Int32(GIT_FILEMODE_TREE.rawValue): "tree",
    Int32(GIT_FILEMODE_BLOB.rawValue): "blob",
    Int32(GIT_FILEMODE_BLOB_EXECUTABLE.rawValue): "blobExecutable",
    Int32(GIT_FILEMODE_LINK.rawValue): "link",
    Int32(GIT_FILEMODE_COMMIT.rawValue): "commit",
]

struct EntryView: View {
    var repo: Repository
    var entry: Tree.Entry
    var error: Error?
        
    var parent: Tree.Entry?
    var blob: Blob?
    var tree: Tree?
    
    @State var showContent = false
    var name: String
    
    var mode: String
    var isUnreadable = false
    var isTree = false
    var isBlob = false
    var isBlobExecutable = false
    var isLink = false
    var isCommit = false
    
    init(repo: Repository, entry: Tree.Entry, parent: Tree.Entry? = nil, showContent: Bool = false) {
        self.repo = repo
        self.entry = entry
        self.parent = parent
        _showContent = State(initialValue: showContent)
                        
        self.mode = filemodesByFlag[entry.attributes]!
        
        self.name = entry.name
//        if parent != nil {
//            self.name = "\(parent!.name)/\(entry.name)"
//        }
        
        switch entry.attributes {
        case Int32(GIT_FILEMODE_UNREADABLE.rawValue):
            isUnreadable = true
        case Int32(GIT_FILEMODE_TREE.rawValue):
            isTree = true
        case Int32(GIT_FILEMODE_BLOB.rawValue):
            isBlob = true
        case Int32(GIT_FILEMODE_BLOB_EXECUTABLE.rawValue):
            isBlobExecutable = true
        case Int32(GIT_FILEMODE_LINK.rawValue):
            isLink = true
        case Int32(GIT_FILEMODE_COMMIT.rawValue):
            isCommit = true
        default:
            break
        }

        if isBlob {
            let oid = entry.object.oid
            switch repo.blob(oid) {
            case let .success(obj):
                self.blob = obj
            case let .failure(error):
                self.error = error
            }
        }
        
        if isTree {
            let oid = entry.object.oid
            switch repo.tree(oid) {
            case let .success(obj):
                self.tree = obj
            case let .failure(error):
                self.error = error
            }
        }
    }
    
//    @State private var pick: Tree.Entry?
    @State private var pick: PresentableEntry?
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                self.pick = PresentableEntry(entry: self.entry, blob: self.blob)
                print("picked \(self.entry.name)")
                self.showContent = !self.showContent
            }) {
                if isTree {
                    if self.showContent {
                        Text("+ \(self.name)")
                    } else {
                        Text("- \(self.name)")
                    }
                }
                if isBlob {
                    Text("\(self.name)")
                }
            }.buttonStyle(PlainButtonStyle()).padding(.vertical, 2.0).preference(key: CurrentEntryPreferenceKey.self, value: pick)
            
            if self.error != nil {
                ErrorView(error: self.error!)
            }
            
            if self.blob != nil && self.showContent {
                BlobView(blob: blob!)
            }
//            if self.tree != nil && self.showContent {
//                TreeView(repo: repo, tree: tree!, parent: entry).padding([.leading])
//            }
        }
    }
}

//struct EntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        EntryView()
//    }
//}
