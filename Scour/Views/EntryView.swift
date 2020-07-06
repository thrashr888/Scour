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
    var blob: Blob?
    var error: Error?
    
    var mode: String
    var isUnreadable = false
    var isTree = false
    var isBlob = false
    var isBlobExecutable = false
    var isLink = false
    var isCommit = false
    
    init(repo: Repository, entry: Tree.Entry) {
        self.repo = repo
        self.entry = entry
        
        self.mode = filemodesByFlag[entry.attributes]!
        
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
            return
        }

        if !isBlob { return }

        let oid = entry.object.oid
        switch repo.blob(oid) {
        case let .success(obj):
            self.blob = obj
        case let .failure(error):
            self.error = error
        }
    }

    var body: some View {
        VStack {
            Text("-  \(entry.name) (\(mode))")
            if self.error != nil {
                ErrorView(error: self.error!)
            }
            if self.blob != nil {
                BlobView(blob: blob!)
            }
        }
    }
}

//struct EntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        EntryView()
//    }
//}
