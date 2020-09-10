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
        List(commitsModel.entries.sorted { $0.name < $1.name }, id: \.self, selection: $commitsModel.entry) { e in
            if e.attributes == Int32(GIT_FILEMODE_TREE.rawValue) {
                Text("􀄧 \(e.name)").tag(e)
            } else {
                Text(e.name).tag(e)
            }
        }
        .onAppear(perform: loadTree)
    }
}

// struct TreeSelectView_Previews: PreviewProvider {
//    static var previews: some View {
//        TreeSelectView()
//    }
// }
