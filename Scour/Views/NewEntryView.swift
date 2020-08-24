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

var filemodesByFlagNew = [
    Int32(GIT_FILEMODE_UNREADABLE.rawValue): "unreadable",
    Int32(GIT_FILEMODE_TREE.rawValue): "tree",
    Int32(GIT_FILEMODE_BLOB.rawValue): "blob",
    Int32(GIT_FILEMODE_BLOB_EXECUTABLE.rawValue): "blobExecutable",
    Int32(GIT_FILEMODE_LINK.rawValue): "link",
    Int32(GIT_FILEMODE_COMMIT.rawValue): "commit",
]

struct NewEntryView: View {
    var repoUrl: URL
    var repo: Repository?
    var entry: Tree.Entry
    
    var error: Error? = nil
        
    var blob: Blob?
    var tree: Tree?
    
    var mode: String
    var isUnreadable = false
    var isTree = false
    var isBlob = false
    var isBlobExecutable = false
    var isLink = false
    var isCommit = false

    init(repoUrl: URL, entry: Tree.Entry) {
        self.repoUrl = repoUrl
        
        switch Repository.at(repoUrl) {
        case let .success(repo):
            self.repo = repo

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
                switch self.repo!.blob(oid) {
                case let .success(obj):
                    self.blob = obj
                case let .failure(error):
                    self.error = error
                }
            }
        case let .failure(error):
            self.error = error
        }
        
        self.entry = entry
                        
        self.mode = filemodesByFlagNew[entry.attributes]!
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if isBlob {
                Text("\(entry.name)")
                    .fontWeight(.bold)
                    .padding(.horizontal)
            }
            
            if self.error != nil {
                ErrorView(error: self.error!)
            }
            
            if self.blob != nil {
                BlobView(blob: blob!, name: entry.name)
            } else {
                Text("")
            }
        }
        .padding(.top)
    }
}

//struct NewEntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        EntryView()
//    }
//}
