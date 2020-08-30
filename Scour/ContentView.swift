//
//  ContentView.swift
//  Scour
//
//  Created by Paul Thrasher on 6/14/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftGit2
import SwiftUI

struct PresentableEntry: Equatable, Identifiable {
    let id = UUID()
    let entry: Tree.Entry
    let blob: Blob?

    static func == (lhs: PresentableEntry, rhs: PresentableEntry) -> Bool {
        lhs.id == rhs.id
    }
}

struct CurrentEntryPreferenceKey: PreferenceKey {
    static var defaultValue: PresentableEntry?
    static func reduce(value: inout PresentableEntry?, nextValue: () -> PresentableEntry?) {
        value = nextValue()
    }
}

struct ContentView: View {
    @ObservedObject var commitsModel = CommitsModel()

    @State var entry: Tree.Entry? = nil

    func prevCommit() {
        commitsModel.prevCommit()
        guard let commit = commitsModel.commit, let entry = self.entry else { return }
        loadEntry(commit, entry)
    }

    func nextCommit() {
        commitsModel.nextCommit()
        guard let commit = commitsModel.commit, let entry = self.entry else { return }
        loadEntry(commit, entry)
    }

    func loadEntry(_ commit: Commit, _ entry: Tree.Entry) {
        guard let repo = commitsModel.repo else { return }

        // TODO: cache or memoize this?

        switch repo.tree(commit.tree.oid) {
        case let .success(obj):

            for e in obj.entries {
                if entry.name == e.value.name {
                    self.entry = e.value
                }
            }

        case .failure:
            return
        }
    }

    var body: some View {
        HStack {
            HStack {
                FinderView(entry: $entry, commitsModel: commitsModel)
                    .frame(minWidth: 200, maxWidth: 300, minHeight: 300, maxHeight: .infinity)
                    .padding(.trailing)

                VStack {
                    if commitsModel.commit != nil {
                        HStack {
                            CommitsLineView(entry: $entry, commitsModel: commitsModel)
                            Button("<", action: prevCommit)
                            Button(">", action: nextCommit)
                        }
                        .padding(.top, 8.0)
                        .padding(.trailing, 5.0)

                        CommitSelectSingleView(commit: commitsModel.commit!)
                            .padding(.trailing, 5.0)

                        Divider()
                    }
                    if commitsModel.repoUrl != nil && entry != nil {
                        NewEntryView(repoUrl: commitsModel.repoUrl!, entry: entry!)
                            .frame(minWidth: 300, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
                    } else {
                        Text(" ")
                            .frame(minWidth: 300, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
