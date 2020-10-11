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
import Down

class ScourModel: ObservableObject {
    @Published var error: Error?
    @Published var selectedRepositoryID: RepositoryModel.ID?
    @Published var repositories: [RepositoryModel] = []
    
    init(){
//        DispatchQueue.main.async {
//            self.load()
//        }
    }
    
    var selectedRepository: RepositoryModel? {
        guard let id = selectedRepositoryID else { return nil }
        
        guard let repository = repositories.first(where: { $0.id == id }) else { return nil }
        return repository
    }
    
    func load() {
        print("Scour.load")
        var rs: [RepositoryModel] = []
        let urls = UrlStore.index()
        for url in urls {
            guard let repo = self.fromUrl(url) else {
                self.error = NSError(domain: "Could not load \(url)", code: 1)
                continue
            }
            rs.append(repo)
        }
        self.repositories = rs
    }
    
    func fromUrl(_ url: URL) -> RepositoryModel? {
        switch Repository.at(url) {
        case let .success(repo):
            return RepositoryModel(self, url: url, repo: repo)
        case .failure:
            return nil
        }
    }
    
    func addRepository(_ url: URL) {
        guard let repo = self.fromUrl(url) else {
            self.error = NSError(domain: "Could not load \(url)", code: 1)
            return
        }
        self.repositories.append(repo)
        
        _ = UrlStore.insert(url: url)
        self.load()
    }
}

class RepositoryModel: ObservableObject, Identifiable, Hashable {
    var parent: ScourModel
    @Published var id: UUID = UUID()
    var name: String
    var description: String { url.relativePath }
    private var url: URL
    private var repo: Repository
    
    @Published var error: Error?
    @Published var selectedBranchID: BranchModel.ID?
    @Published var branches: [BranchModel] = []
    
    init(_ parent: ScourModel, url: URL, repo: Repository) {
        self.parent = parent
        self.url = url
        self.repo = repo
        self.name = repo.directoryURL?.lastPathComponent ?? "unnamed repo"
    }
    
    func load() {
        print("Repository.\(id).load")
        self.branches = []
        switch self.repo.localBranches() {
        case let .success(obj):
            for (_, b) in obj.enumerated() {
                print("Repository.load.branch:", b.name)
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
    var description: String { branch.longName }
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
//        DispatchQueue.main.async {
//        }
        // TODO: background queue for rendering the commit line?
        // TODO: paginate this
        var page = 0
        self.commits = []
        for commit in repo.commits(in: branch) {
            switch commit {
            case nil:
                break
            case let .success(c):
                print("Branch.load.commit =", c.oid.description)
                let cm = CommitModel(self, repo: self.repo, branch: self.branch, commit: c)
                self.commits.append(cm)
                page += 1
                if page > 2 {
                    break
                }
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

class CommitModel: ObservableObject, Identifiable, Hashable {
    var parent: BranchModel
    var id: String { commit.oid.description }
    var name: String { commit.oid.description }
    private var repo: Repository
    private var branch: Branch
    private var commit: Commit
    
    @Published var error: Error?
    @Published var entries: [EntryModel] = []
    
    var authorName: String { commit.author.name }
    var committerTime: Date { commit.committer.time }
    var oidDescription: String { commit.oid.description }
    var message: String { commit.message }
    var treeOidDescription: String { commit.tree.oid.description }
    
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
    
    public func hash(into hasher: inout Hasher) {
         hasher.combine(ObjectIdentifier(self).hashValue)
    }
    static func == (lhs: CommitModel, rhs: CommitModel) -> Bool {
        lhs.id == rhs.id
    }
}

class EntryModel: ObservableObject, Identifiable, Hashable, Comparable {
    var parent: CommitModel
    var id: String { entry.object.oid.description }
    var name: String { entry.name }
    var description: String { entry.description }
    private var repo: Repository
    private var branch: Branch
    private var commit: Commit
    private var entry: Tree.Entry
    
    @Published var error: Error?
    @Published var entries: [EntryModel] = []
    @Published var blob: BlobModel?

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
    }
    
    func load(){
        guard isTree else { return }
        
        self.entries = []
        switch repo.tree(entry.object.oid) {
        case let .success(obj):
            for e in obj.entries {
                print("Entry.load.entry = ", e.value.name)
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
            print("Entry.load.blob = ", obj.hashValue)
            self.blob = BlobModel(self, repo: self.repo, branch: self.branch, commit: self.commit, entry: self.entry, blob: obj)
        case let .failure(err):
            self.error = err
        }
    }
    
    public func hash(into hasher: inout Hasher) {
         hasher.combine(ObjectIdentifier(self).hashValue)
    }
    static func == (lhs: EntryModel, rhs: EntryModel) -> Bool {
        lhs.id == rhs.id
    }
    static func < (lhs: EntryModel, rhs: EntryModel) -> Bool {
        (lhs.isTree == rhs.isTree) ? lhs.name < rhs.name : lhs.isTree
    }
}

class BlobModel: ObservableObject, Identifiable, Hashable {
    var parent: EntryModel
    var id: String { entry.object.oid.description }
    var name: String { entry.name }
    private var repo: Repository
    private var branch: Branch
    private var commit: Commit
    private var entry: Tree.Entry
    private var blob: Blob
    
    var content: String? { String(data: blob.data, encoding: .utf8) }
    var isMarkdown: Bool { name.hasSuffix(".md") }
    var md: Down? {
        guard isMarkdown else { return nil }
        guard let str = self.content else { return nil }
        return Down(markdownString: str)
    }
    var attributedStr: NSAttributedString? {
        guard let md = self.md else { return nil }
        return try? md.toAttributedString()
    }
        
    init(_ parent: EntryModel, repo: Repository, branch: Branch, commit: Commit, entry: Tree.Entry, blob: Blob) {
        self.parent = parent
        self.repo = repo
        self.branch = branch
        self.commit = commit
        self.entry = entry
        self.blob = blob
    }
    
    public func hash(into hasher: inout Hasher) {
         hasher.combine(ObjectIdentifier(self).hashValue)
    }
    static func == (lhs: BlobModel, rhs: BlobModel) -> Bool {
        lhs.id == rhs.id
    }
}
