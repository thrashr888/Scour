//
//  CommitsModel.swift
//  Scour
//
//  Created by Paul Thrasher on 8/24/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import Clibgit2
import Foundation
import SwiftGit2

class CommitsModel: ObservableObject {
    @Published var loading = false
    
    @Published var repo: Repository?
    @Published var repoName: String?
    @Published var repoUrl: URL? {
        didSet {
            guard let url = repoUrl else {
                repo = nil
                repoName = nil
                branches = []
                branch = nil
                commitIterator = nil
                commits = []
                commit = nil
                return
            }
            repoName = repoUrl?.lastPathComponent
            switch Repository.at(url) {
            case let .success(repo):
                self.repo = repo
                self.loadBranches()
                branch = nil
                commitIterator = nil
                commits = []
                commit = nil
            case .failure:
                return
            }
        }
    }

    @Published var branches: [Branch] = []
    @Published var branch: Branch? {
        didSet {
            guard branch != nil else {
                commitIterator = nil
                commits = []
                commit = nil
                return
            }
            commitIterator = nil
            commits = []
            commit = nil
            loadNextCommits()
        }
    }

    @Published var commits: [Commit] = []
    @Published var commit: Commit?
    
    @Published var entries: [Tree.Entry] = []
    @Published var entry: Tree.Entry?
    @Published var blob: Blob?
    
    var blobCache: [OID: Blob] = [:]

    func prevCommit() {
        guard let current = commit else { return }

        for (i, commit) in commits.enumerated() {
            if commit == current {
                if i == 0 { return }

                print("prev \(i - 1)")
                self.commit = commits[i - 1]
                self.loadEntry(self.commit!, self.entry!)
                return
            }
        }
    }

    func nextCommit() {
        guard let current = commit else { return }

        // TODO: this always goes straight to the end for some reason
        for (i, commit) in commits.enumerated() {
            if commit == current {
                if i == commits.count - 1 { return }

                print("next \(i + 1) \(commits.count)")
                self.commit = commits[i + 1]
                self.loadEntry(self.commit!, self.entry!)
                return
            }
        }
    }

    func loadBranches() {
        guard let repo = self.repo else { return }
        
        switch repo.localBranches() {
        case let .success(obj):
            branches = obj
//                for (_, branch) in obj.enumerated() {
//                    if branch.name == "master" {
//                        self.currentBranch = branch
//                    }
//                }
        case .failure:
            return
        }
    }

    func loadCommits() {
        guard let repo = self.repo, let branch = self.branch else { return }

        // TODO: paginate this
        loading = true
        for commit in repo.commits(in: branch) {
            switch commit {
            case nil:
                loading = false
                return
            case let .success(obj):
                commits.append(obj)
//                if self.currentCommit == nil {
//                    self.currentCommit = obj
//                }
                loading = false
            case .failure:
                loading = false
                return
            }
        }
    }
    
    var commitIterator: CommitIterator?
    var commitPageCount = 20
    var loadingCommits = false
    var hasMoreCommits = true
    func loadNextCommits() {
        guard let repo = self.repo, let branch = self.branch else { return }
        
        // first load
        if commitIterator == nil {
            commitIterator = repo.commits(in: branch)
        }
        
        guard let commitIterator = self.commitIterator else { return }
        
        loadingCommits = true
        var loopCount = -1
        for commit in commitIterator {
            switch commit {
            case nil:
                hasMoreCommits = false
            case let .success(obj):
                commits.append(obj)
            case .failure:
                return
            }

            loopCount += 1
            if loopCount == commitPageCount {
                break
            }
        }
        if loopCount < commitPageCount {
            hasMoreCommits = false
        }
        print("done \(loopCount) \(commitPageCount)")
//        print(commits)
        loadingCommits = false
    }

    
    func loadTree(_ commit: Commit) {
        guard let repo = self.repo else { return }

        loading = true
        switch repo.tree(commit.tree.oid) {
        case let .success(obj):

            for entry in obj.entries {
                if entry.value.attributes == Int32(GIT_FILEMODE_TREE.rawValue) {
                    entries.append(entry.value)
                } else if entry.value.attributes == Int32(GIT_FILEMODE_BLOB.rawValue) {
                    entries.append(entry.value)

                    // select first file
                    if self.entry == nil {
                        self.entry = entry.value
                    }
                    print("\(entry.value.name)")
                    if entry.value.name.lowercased() == "readme.md" {
                        self.entry = entry.value
                    }
                }
            }
            loading = false

        case .failure:
            loading = false
            return
        }
    }
    
    func loadEntry(_ commit: Commit, _ entry: Tree.Entry) {
        guard let repo = self.repo else { return }

        // TODO: cache or memoize this?

        loading = true
        switch repo.tree(commit.tree.oid) {
        case let .success(obj):

            for e in obj.entries {
                if entry.name == e.value.name {
                    self.entry = e.value
                    return
                }
            }
            loading = false

        case .failure:
            loading = false
            return
        }
        
        return
    }
    
    func loadBlob(_ entry: Tree.Entry) -> Blob? {
        guard let repo = self.repo else { return nil }
        
        // cached
        if let blob = blobCache[entry.object.oid] {
            return blob
        }
        
        let oid = entry.object.oid
        
        loading = true
        switch repo.blob(oid) {
        case let .success(obj):
            blobCache[entry.object.oid] = obj // cache it
            loading = false
            return obj
        case .failure:
            loading = false
            return nil
        }
    }

    func fetch(_ remote: String = "origin") -> Error? {
        guard let repo = self.repo else { return nil }

        loading = true
        switch repo.remote(named: "origin") {
        case let .success(remote):
            switch repo.fetch(remote) {
            case .success():
                loading = false
                return nil
            case let .failure(error):
                loading = false
                return error
            }
        case let .failure(error):
            loading = false
            return error
        }
    }
}
