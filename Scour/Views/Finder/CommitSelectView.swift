//
//  CommitSelectView.swift
//  Scour
//
//  Created by Paul Thrasher on 8/13/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import Clibgit2
import SwiftGit2
import SwiftUI

struct CommitSelectSingleView: View {
    var commit: Commit

    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .lastTextBaseline) {
                Text(commit.author.name)
                    .foregroundColor(Color.orange).truncationMode(.tail)
                Text("\(commit.committer.time, formatter: Self.taskDateFormat)").multilineTextAlignment(.trailing)
                Spacer()
                Text(commit.oid.description).frame(width: 60.0, height: 13.0).truncationMode(.tail)
            }
            HStack {
                Text(commit.message).frame(height: 13.0).truncationMode(.tail)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
    }
}

struct CommitSelectView: View {
    @ObservedObject var commitsModel: CommitsModel

    var body: some View {
        List(commitsModel.commits, id: \.self, selection: $commitsModel.commit) { commit in
            CommitSelectSingleView(commit: commit).tag(commit)
        }
        .padding(.vertical, 1)
        .padding(.horizontal, 3)
    }
}

// struct CommitSelectView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommitSelectView()
//    }
// }
