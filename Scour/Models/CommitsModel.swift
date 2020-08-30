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
    @Published var repoUrl: URL? {
        didSet {
            guard let url = repoUrl else {
                repo = nil
                branch = nil
                commits = []
                commit = nil
                return
            }
            switch Repository.at(url) {
            case let .success(repo):
                self.repo = repo
                branch = nil
                commits = []
                commit = nil
            case .failure:
                return
            }
        }
    }

    @Published var repo: Repository?
    @Published var branch: Branch? {
        didSet {
            guard branch != nil else {
                commits = []
                commit = nil
                return
            }
            commits = []
            commit = nil
            loadCommits()
        }
    }

    @Published var commits: [Commit] = []
    @Published var commit: Commit?

    func prevCommit() {
        guard let current = commit else { return }

        for (i, commit) in commits.enumerated() {
            if commit == current {
                if i == 0 { return }

                print("prev \(i - 1)")
                self.commit = commits[i - 1]
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
                return
            }
        }
    }

    func loadCommits() {
        guard let repo = self.repo, let branch = self.branch else { return }

        for commit in repo.commits(in: branch) {
            switch commit {
            case nil:
                return
            case let .success(obj):
                commits.append(obj)
//                if self.currentCommit == nil {
//                    self.currentCommit = obj
//                }
            case .failure:
                return
            }
        }
    }

    func fetch(_ remote: String = "origin") -> Error? {
        guard let repo = self.repo else { return nil }

        switch repo.remote(named: "origin") {
        case let .success(remote):
            switch repo.fetch(remote) {
            case .success():
                return nil
            case let .failure(error):
                return error
            }
        case let .failure(error):
            return error
        }
    }
}
