//
//  BranchView.swift
//  Scour
//
//  Created by Paul Thrasher on 7/5/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI
import SwiftGit2
import Clibgit2

struct CommitName: View {
    var commit: Commit
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    var body: some View {
        HStack(alignment: .top) {
            Text(commit.oid.description.suffix(6).description)
                .foregroundColor(Color.gray)
            Text(commit.message).truncationMode(.tail).lineLimit(/*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/).frame(maxWidth: .infinity, alignment: .leading)
            Text("\(commit.committer.time, formatter: Self.taskDateFormat)").foregroundColor(Color.gray).multilineTextAlignment(.trailing)
        }
    }
}

struct KeyEventHandling: NSViewRepresentable {
    var callback: (NSEvent) -> Void
    
    class KeyView: NSView {
        var callback: ((NSEvent) -> Void)? = nil
        override var acceptsFirstResponder: Bool { true }
        override func keyDown(with event: NSEvent) {
            super.keyDown(with: event)
//            print(">> key \(event.charactersIgnoringModifiers ?? "")")
            self.callback!(event)
        }
    }

    func makeNSView(context: Context) -> NSView {
        let view = KeyView()
        view.callback = self.callback
        DispatchQueue.main.async { // wait till next event cycle
            view.window?.makeFirstResponder(view)
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
    }
}

struct BranchView: View {
    @State var error: Error?
    var repo: Repository
    var branch: Branch
    @State var tree: Tree?
    @State var currentCommit: Commit?
    @State var currentCommitIndex: Int = 0
    @State var currentEntry: Tree.Entry?
    @State var loadingTree: Bool = false
    
    var commitIterator: CommitIterator
    @State private var commits: [Commit] = []
    @State var commitPageCount: Int = 15
    @State var loadingCommits: Bool = false
    @State var hasMoreCommits: Bool = true
    
    init(repo: Repository, branch: Branch) {
        self.repo = repo
        self.branch = branch
        
        self.commitIterator = repo.commits(in: branch)

        print("init \(self.repo.directoryURL!.path)")
    }
    
    func isCurrentCommit(commit: Commit) -> Bool {
        return self.currentCommit != nil && commit.oid.description == self.currentCommit!.oid.description
    }
    
    func previousCommit() {
        if self.currentCommitIndex > 0 {
            self.currentCommitIndex -= 1
            self.currentCommit = self.commits[self.currentCommitIndex]
        }
    }
    
    func nextCommit() {
        if self.currentCommitIndex < self.commits.count - 1 {
            self.currentCommitIndex += 1
            self.currentCommit = self.commits[self.currentCommitIndex]
        }
    }
    
    func loadNextCommits() {
        loadingCommits = true
//        print("load")
//        print(commits)
        var loopCount = -1
        for commit in commitIterator {
//            print(commit)
            switch commit {
            case nil:
                self.hasMoreCommits = false
            case let .success(obj):
//                print(obj.oid.description)
                commits.append(obj)
            case let .failure(error):
                self.error = error
            }
            
            loopCount += 1
            if loopCount == commitPageCount {
                break
            }
        }
        if loopCount < commitPageCount {
            self.hasMoreCommits = false
        }
        print("done \(loopCount) \(commitPageCount)")
//        print(commits)
        loadingCommits = false
    }
    
    func loadTree(commit: Commit) {
        switch self.repo.tree(commit.tree.oid) {
        case let .success(obj):
            self.tree = obj
            if self.currentEntry != nil {
                self.currentEntry = obj.entries[self.currentEntry!.name]
            } else {
                let firstKey = obj.entries.keys.sorted()[0]
                self.currentEntry = obj.entries[firstKey]!
            }
        case let .failure(error):
            self.error = error
        }
//        print("done \(self.tree!.oid) \(self.currentEntry!.name)")
    }
    
    func onKeyEvent(event: NSEvent) {
//        print(">> key \(event.charactersIgnoringModifiers ?? "")")
        if event.keyCode == 125 || event.keyCode == 124 || event.keyCode == 47 {
            // down, right, "."
            self.nextCommit()
        } else if event.keyCode == 126 || event.keyCode == 123 || event.keyCode == 43 {
            // up, left, ","
            self.previousCommit()
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if error != nil {
                ErrorView(error: error!)
            }
            
            if currentCommit != nil{
                CommitView(commit: currentCommit!)
            }
            
            HStack(alignment: .top) {
                ScrollView([.vertical]) {
                    VStack(alignment: .leading) {
                        
                        HStack {
                            Button(action: {
                                self.previousCommit()
                            }) {
                                Text("􀄤")
                            }
                            Button(action: {
                                self.nextCommit()
                            }) {
                                Text("􀄥")
                            }
                        }
                        
                        ForEach(commits.indices, id: \.self) { i in

                            Button(action: {
                                if self.loadingTree { return }
                                self.currentCommit = self.commits[i]
                                self.currentCommitIndex = i
                                self.loadTree(commit: self.commits[i])
                                self.loadingTree = false
                            }) {
                                if self.isCurrentCommit(commit: self.commits[i]) {
                                    HStack {
                                        Divider()
                                        CommitName(commit: self.commits[i])
                                    }.padding(0)
                                } else {
                                    CommitName(commit: self.commits[i])
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
//                            .onHover { hovering in
//                                if self.loadingTree { return }
//                                self.currentCommit = self.commits[i]
//                                self.loadTree(commit: self.commits[i])
//                                self.loadingTree = false
//                            }
                            
                        }
                        
                        if hasMoreCommits {
                            Button(action: {
                                self.loadNextCommits()
                            }) {
                                Text("Next").frame(width: 200.0)
                            }
                        }
                    }.padding()
                }
                .frame(width: 300)
                .background(Color(.sRGB, white: 0.1, opacity: 1))
                .onAppear() {
//                    print("onAppear")
                    self.commits = []
                    self.loadNextCommits()
                    self.loadTree(commit: self.commits[0])
                    self.currentCommit = self.commits[0]
                }
                
                if tree != nil {
                    ScrollView([.vertical]) {
                        TreeView(repo: repo, tree: tree!, currentEntry: self.$currentEntry)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                    }
                    .frame(width: 250)
                    .background(Color(.sRGB, white: 0.1, opacity: 1))
                }
                
                if currentEntry != nil {
                    ScrollView([.vertical]) {
                        EntryView(repo: repo, entry: currentEntry!, parent: nil, showContent: true)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                    }
                }
            }
        }
        .background(KeyEventHandling(callback: onKeyEvent))
    }
}

//struct BranchView_Previews: PreviewProvider {
//    static var previews: some View {
//        BranchView()
//    }
//}
