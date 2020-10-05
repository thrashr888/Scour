//
//  OldEntryModel.swift
//  Scour
//
//  Created by Paul Thrasher on 9/7/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import Clibgit2
import Foundation
import SwiftGit2

class OldEntryModel: ObservableObject {
    var entry: Tree.Entry

    var blob: Blob?

    var mode: String
    var isUnreadable = false
    var isTree = false
    var isBlob = false
    var isBlobExecutable = false
    var isLink = false
    var isCommit = false

    init(commitsModel: CommitsModel, entry: Tree.Entry) {
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
            blob = commitsModel.loadBlob(entry)
        }

        self.entry = entry

        mode = filemodesByFlagNew[entry.attributes]!
    }
}

var filemodesByFlagNew = [
    Int32(GIT_FILEMODE_UNREADABLE.rawValue): "unreadable",
    Int32(GIT_FILEMODE_TREE.rawValue): "tree",
    Int32(GIT_FILEMODE_BLOB.rawValue): "blob",
    Int32(GIT_FILEMODE_BLOB_EXECUTABLE.rawValue): "blobExecutable",
    Int32(GIT_FILEMODE_LINK.rawValue): "link",
    Int32(GIT_FILEMODE_COMMIT.rawValue): "commit",
]
