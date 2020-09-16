//
//  CommitsLineView.swift
//  Scour
//
//  Created by Paul Thrasher on 8/25/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import Clibgit2
import SwiftGit2
import SwiftUI

struct CommitsLineView: View {
    @Binding var entry: Tree.Entry?

    @ObservedObject var commitsModel: CommitsModel

    var body: some View {
        HStack {
            ForEach(commitsModel.commits, id: \.self) { commit in
                Group {
                    if commit == self.commitsModel.commit {
                        Button("●") {
                            self.commitsModel.loadEntry(commit, self.entry!)
                        }.buttonStyle(PlainButtonStyle())
                    } else {
                        Button("・") {
                            self.commitsModel.loadEntry(commit, self.entry!)
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
}

struct CommitsLineView_Previews: PreviewProvider {
    static var previews: some View {
        CommitsLineView(
            entry: .constant(nil),
            commitsModel: CommitsModel()
        )
    }
}
