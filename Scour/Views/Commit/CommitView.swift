//
//  CommitView.swift
//  Scour
//
//  Created by Paul Thrasher on 10/6/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

struct CommitView: View {
    var commit: CommitModel
    
    @State private var presentingOrderPlacedSheet = false
    @EnvironmentObject private var model: ScourModel
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var selectedEntryID: EntryModel.ID?
    @State private var topmostEntryID: EntryModel.ID?
    @Namespace private var namespace
    
    var body: some View {
        Group {
            Text("commit.body.group")
        }
        .background(Rectangle().fill(BackgroundStyle()).edgesIgnoringSafeArea(.all))
        .navigationTitle(commit.name)
    }
}
