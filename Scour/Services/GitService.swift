//
//  GitService.swift
//  Scour
//
//  Created by Paul Thrasher on 7/4/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import Foundation
import SwiftGit2

class Commitservice: ObservableObject {
    @Published var lastError: Error?
    @Published var lastCommit: Error?

    var oid: OID

    init(oid: OID) {
        self.oid = oid
    }
}

class Reposervice: ObservableObject {
    @Published var lastError: Error?
    @Published var lastCommit: Error?

    var url: URL
    var repo: Repository
    var currentOID: OID?
    var currentBranch: String = "master"

    init(url: URL, repo: Repository) {
        self.url = url
        self.repo = repo
        _ = head()
    }

    func head() -> OID? {
        let result = repo.HEAD().map {
            $0.oid
        }
        switch result {
        case let .success(latestOID):
            print("oid: \(latestOID)")
            currentOID = latestOID
            return latestOID
        case let .failure(error):
            lastError = error
            return nil
        }
    }

    func tree() -> Tree? {
//        let oid = OID(string: "ae137a37d0715c0e2df57a64f338c1c09f48eef5")!
//        let pointer = Pointer.tree(oid)
//        let tree = repo.tree(oid)
//        let res = repo.object(from: pointer).map { $0 as! Tree }

//        repo.tree(OID("ae137a37d0715c0e2df57a64f338c1c09f48eef5"))
        let res = repo.HEAD().flatMap {
            repo.tree($0.oid)
        }
//        let res = repo.tree(oid)

        switch res {
        case let .success(obj):
            return obj
        case let .failure(error):
            lastError = error
            return nil
        }
    }

    func branches() -> [Branch]? {
        let res = repo.localBranches()
        switch res {
        case let .success(obj):
            return obj
        case let .failure(error):
            lastError = error
            return nil
        }
    }

    func unwrapCommit(res: Result<Commit, NSError>) -> Commit? {
        switch res {
        case let .success(obj):
            return obj
        case let .failure(error):
            lastError = error
            return nil
        }
    }

    func commits() -> [Commit]? {
        guard let branches = self.branches() else { return nil }

        var commits: [Commit] = []
        for branch in branches {
            for res in repo.commits(in: branch) {
                guard let commit = unwrapCommit(res: res) else { continue }
                commits.append(commit)
            }
        }
        return commits
    }

    func latestCommit() -> Commit? {
        let res = repo.HEAD().flatMap {
            repo.commit($0.oid)
        }
        return unwrapCommit(res: res)
    }

    func blob() -> Blob? {
//        return repo!.blob(self.currentOID!)

        let oid = OID(string: "ae137a37d0715c0e2df57a64f338c1c09f48eef5")!

//        let res = repo.HEAD().flatMap {
//            repo.blob($0.oid)
//        }
        let res = repo.blob(oid)

        switch res {
        case let .success(obj):
            return obj
        case let .failure(error):
            lastError = error
            return nil
        }
    }
}

class Gitservice: ObservableObject {
    @Published var repo: Reposervice?
    @Published var lastError: Error?

    init(_ path: String) {
        loadRepo(path)
    }

    func loadRepo(_ path: String) {
        let url = URL(fileURLWithPath: path)
        let result = Repository.at(url)

        switch result {
        case let .success(repo):
            self.repo = Reposervice(url: url, repo: repo)
        case let .failure(error):
            lastError = error
        }
    }

    func error() -> Error? {
        if lastError != nil {
            return lastError
        } else if (repo?.lastError) != nil {
            return repo?.lastError
        }
        return nil
    }
}
