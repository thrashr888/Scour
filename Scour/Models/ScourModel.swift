//
//  RepoModel.swift
//  Scour
//
//  Created by Paul Thrasher on 9/25/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI
import Clibgit2
import Foundation
import SwiftGit2

class ScourModel: ObservableObject {
    @Published var error: Error?
    @Published var selectedRepositoryID: RepositoryModel.ID?
    @Published var repositories: [RepositoryModel] = []
    
    init(){
//        DispatchQueue.main.async {
            self.load()
//        }
    }
    
    var selectedRepository: RepositoryModel? {
        guard let id = selectedRepositoryID else { return nil }
        
        guard let repository = repositories.first(where: { $0.id == id }) else { return nil }
        return repository
    }
    
    func load() {
        var rs: [RepositoryModel] = []
        let urls = UrlStore.index()
        for url in urls {
            switch Repository.at(url) {
            case let .success(repo):
                rs.append(RepositoryModel(self, url: url, repo: repo))
            case let .failure(err):
                self.error = err
                continue
            }
        }
        self.repositories = rs
    }
}

class RepositoryModel: ObservableObject, Identifiable, Hashable {
    var parent: ScourModel
    @Published var id: UUID = UUID()
    var name: String
    private var url: URL
    private var repo: Repository
    
    @Published var error: Error?
    @Published var branches: [BranchModel] = []
    
    init(_ parent: ScourModel, url: URL, repo: Repository) {
        self.parent = parent
        self.url = url
        self.repo = repo
        self.name = repo.directoryURL?.lastPathComponent ?? "unnamed repo"
    }
    
    func load() {
        print("Repository.load")
        self.branches = []
        switch self.repo.localBranches() {
        case let .success(obj):
            for (_, b) in obj.enumerated() {
                print("Repository.load.branch =", b.name)
                let bm = BranchModel(self, repo: self.repo, branch: b)
                self.branches.append(bm)
            }
        case let .failure(err):
            self.error = err
        }
    }
    
    func fetch(_ remote: String = "origin") {
        switch repo.remote(named: remote) {
        case let .success(r):
            switch repo.fetch(r) {
            case .success():
                break
            case let .failure(err):
                self.error = err
            }
        case let .failure(err):
            self.error = err
        }
    }
    
    public func hash(into hasher: inout Hasher) {
         hasher.combine(ObjectIdentifier(self).hashValue)
    }
    static func == (lhs: RepositoryModel, rhs: RepositoryModel) -> Bool {
        lhs.id == rhs.id
    }
}

class BranchModel: ObservableObject, Identifiable, Hashable {
    var parent: RepositoryModel
    var id: String { branch.oid.description }
    var name: String { branch.name }
    private var repo: Repository
    private var branch: Branch
    
    @Published var error: Error?
    @Published var commits: [CommitModel] = []
    
    init(_ parent: RepositoryModel, repo: Repository, branch: Branch) {
        self.parent = parent
        self.repo = repo
        self.branch = branch
    }
    
    func load(){
        
        DispatchQueue.main.async {
        }
        // TODO: background queue for rendering the commit line?
        // TODO: paginate this
        self.commits = []
        for commit in repo.commits(in: branch) {
            switch commit {
            case nil:
                break
            case let .success(c):
                print("Branch.load.commit =", c.oid.description)
                let cm = CommitModel(self, repo: self.repo, branch: self.branch, commit: c)
                self.commits.append(cm)
            case let .failure(err):
                self.error = err
            }
        }
    }
    
    public func hash(into hasher: inout Hasher) {
         hasher.combine(ObjectIdentifier(self).hashValue)
    }
    static func == (lhs: BranchModel, rhs: BranchModel) -> Bool {
        lhs.id == rhs.id
    }
}

class CommitModel: ObservableObject, Identifiable {
    var parent: BranchModel
    var id: String { commit.oid.description }
    var name: String { commit.oid.description }
    private var repo: Repository
    private var branch: Branch
    private var commit: Commit
    
    @Published var error: Error?
    @Published var entries: [EntryModel] = []
    
    init(_ parent: BranchModel, repo: Repository, branch: Branch, commit: Commit) {
        self.parent = parent
        self.repo = repo
        self.branch = branch
        self.commit = commit
    }
    
    func load(){
        self.entries = []
        switch repo.tree(commit.tree.oid) {
        case let .success(obj):
            for e in obj.entries {
                print("Commit.load.entry = ", e.value.name)
                let em = EntryModel(self, repo: self.repo, branch: self.branch, commit: self.commit, entry: e.value)
                self.entries.append(em)
            }
        case let .failure(err):
            self.error = err
        }
    }
}

class EntryModel: ObservableObject, Identifiable {
    var parent: CommitModel
    var id: String { entry.object.oid.description }
    var name: String { entry.name }
    private var repo: Repository
    private var branch: Branch
    private var commit: Commit
    private var entry: Tree.Entry
    
    @Published var error: Error?
    @Published var entries: [EntryModel] = []
    
    var blob: Blob?

    var mode: String
    var isUnreadable = false
    var isTree = false
    var isBlob = false
    var isBlobExecutable = false
    var isLink = false
    var isCommit = false

    init(_ parent: CommitModel, repo: Repository, branch: Branch, commit: Commit, entry: Tree.Entry) {
        self.parent = parent
        self.repo = repo
        self.branch = branch
        self.commit = commit
        self.entry = entry
    
        self.mode = filemodesByFlagNew[entry.attributes]!
        switch entry.attributes {
        case Int32(GIT_FILEMODE_UNREADABLE.rawValue):
            isUnreadable = true
        case Int32(GIT_FILEMODE_TREE.rawValue):
            isTree = true
        case Int32(GIT_FILEMODE_BLOB.rawValue):
            isBlob = true
        case Int32(GIT_FILEMODE_BLOB_EXECUTABLE.rawValue):
            isBlobExecutable = true
        case Int32(GIT_FILEMODE_LINK.rawValue):
            isLink = true
        case Int32(GIT_FILEMODE_COMMIT.rawValue):
            isCommit = true
        default:
            break
        }

        if isBlob {
            self.loadBlob()
        }
    }
    
    func load(){
        self.entries = []
        switch repo.tree(entry.object.oid) {
        case let .success(obj):
            for e in obj.entries {
                print("Commit.load.entry = ", e.value.name)
                let em = EntryModel(self.parent, repo: self.repo, branch: self.branch, commit: self.commit, entry: e.value)
                self.entries.append(em)
            }
        case let .failure(err):
            self.error = err
        }
    }
    
    func loadBlob() {
        let oid = self.entry.object.oid

        switch repo.blob(oid) {
        case let .success(obj):
            blob = obj
        case let .failure(err):
            self.error = err
        }
    }
}
