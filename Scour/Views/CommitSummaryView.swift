//
//  CommitSummaryView.swift
//  Scour
//
//  Created by Paul Thrasher on 9/23/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

struct CommitSummaryView: View {
    @ObservedObject var commitsModel: CommitsModel

    var body: some View {
        HStack {
            if commitsModel.commit != nil {
                Text("\(commitsModel.repoName!)#\(commitsModel.branch!.name)@\(String(commitsModel.commit!.tree.oid.description.prefix(6)))/\(commitsModel.entry?.name ?? "")")

            } else if commitsModel.branch != nil {
                Text("\(commitsModel.repoName!)#\(commitsModel.branch!.name)")

            } else if commitsModel.repoName != nil {
                Text("\(commitsModel.repoName!)")
            }
        }
    }
}
