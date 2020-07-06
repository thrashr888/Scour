//
//  CommitView.swift
//  Scour
//
//  Created by Paul Thrasher on 7/5/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI
import SwiftGit2

struct CompactCommitView: View {
    var commit: Commit
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .lastTextBaseline) {
                Text(commit.author.name)
                    .foregroundColor(Color.orange).truncationMode(.tail)
                Spacer()
                Text(commit.oid.description).frame(width: 80.0, height: 13.0).truncationMode(.tail)
            }
            HStack {
                Text(commit.message).frame(height: 13.0).truncationMode(.tail)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
    }
}

struct CommitView: View {
    var commit: Commit
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .lastTextBaseline) {
                Text(commit.author.name)
                    .foregroundColor(Color.orange).bold().truncationMode(.tail)
                Spacer()
                Text(commit.oid.description).font(.subheadline).bold().truncationMode(.tail)
            }
            Text(commit.message).truncationMode(.tail)
        }
        .padding([.top, .leading, .trailing])
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
        .background(Color.white.opacity(0.3))
    }
}

//struct CommitView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommitView()
//    }
//}
