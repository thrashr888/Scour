//
//  ContentView.swift
//  Scour
//
//  Created by Paul Thrasher on 6/14/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI
import SwiftGit2

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
    @State var repoUrl: URL? = nil
    @State var branch: Branch? = nil
    @State var commits: [Commit] = []
    @State var commit: Commit? = nil
    @State var entry: Tree.Entry? = nil
    
    @State var currentUrl: URL = URL(fileURLWithPath: "/Users/thrashr888/workspace/Scour")
    // https://github.com/SwiftGit2/SwiftGit2.git
    
    func prevCommit() {
        for (i, commit) in self.commits.enumerated() {
            if commit == self.commit {
                if i == 0 { return }
                
                self.commit = self.commits[i-1]
                loadEntry(self.commit!, self.entry!)
            }
        }
    }
    func nextCommit() {
        for (i, commit) in self.commits.enumerated() {
            if commit == self.commit {
                if i == self.commits.count - 1 { return }
                
                self.commit = self.commits[i+1]
                loadEntry(self.commit!, self.entry!)
            }
        }
    }
    func loadEntry(_ commit: Commit, _ entry: Tree.Entry) {
        switch Repository.at(self.repoUrl!) {
        case let .success(repo):
            switch repo.tree(commit.tree.oid) {
            case let .success(obj):

                for e in obj.entries {
                    if entry.name == e.value.name {
                        self.entry = e.value
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
        HStack {
            HStack {
                FinderView(repoUrl: $repoUrl, branch: $branch, commits: $commits, commit: $commit, entry: $entry).frame(minWidth: 200, maxWidth: 300, minHeight: 300, maxHeight: .infinity).padding(.trailing)

                VStack {
                    if commit != nil {
                        HStack {
                            CommitSelectSingleView(commit: commit!)
                            Button("<", action: prevCommit)
                            Button(">", action: nextCommit)
                        }
                        .padding(.top, 8.0).padding(.trailing, 5.0)
                        Divider()
                    }
                    if repoUrl != nil && entry != nil {
                        NewEntryView(repoUrl: repoUrl!, entry: entry!).frame(minWidth: 300, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
                    } else {
                        Text(" ").frame(minWidth: 300, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
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
