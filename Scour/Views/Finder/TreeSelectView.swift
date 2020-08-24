//
//  TreeSelectView.swift
//  Scour
//
//  Created by Paul Thrasher on 8/13/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI
import SwiftGit2
import Clibgit2

struct TreeSelectView: View {
    // input
    var repoUrl: URL
    var commit: Commit
    
    // internal
    @State var parentEntry: Tree.Entry? = nil
    @State var entries: [Tree.Entry] = []
    
    // bound
    @Binding var currentEntry: Tree.Entry?
    
    func loadTree() {
        switch Repository.at(self.repoUrl) {
        case let .success(repo):
            switch repo.tree(self.commit.tree.oid) {
            case let .success(obj):

                for entry in obj.entries {
                    if entry.value.attributes == Int32(GIT_FILEMODE_TREE.rawValue) {
                        self.entries.append(entry.value)
                    } else if entry.value.attributes == Int32(GIT_FILEMODE_BLOB.rawValue) {
                        self.entries.append(entry.value)
                        if self.currentEntry == nil {
                            self.currentEntry = entry.value
                        }
                    }
                }
                
            case .failure(_):
                return
            }
        case .failure(_):
            return
        }
    }
        
    var body: some View {
        List(self.entries.sorted { $0.name < $1.name }, id: \.self, selection: $currentEntry) { entry in
            if entry.attributes == Int32(GIT_FILEMODE_TREE.rawValue) {
                Text("􀄧 \(entry.name)").tag(entry)
            } else {
                Text(entry.name).tag(entry)
            }
        }.onAppear(perform: loadTree)
    }
}

//struct TreeSelectView_Previews: PreviewProvider {
//    static var previews: some View {
//        TreeSelectView()
//    }
//}
