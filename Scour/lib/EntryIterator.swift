//
//  EntryIterator.swift
//  Scour
//
//  Created by Paul Thrasher on 10/17/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import Foundation
import SwiftGit2
import Clibgit2

public class EntryIterator: IteratorProtocol, Sequence {
    public typealias Iterator = EntryIterator
    public typealias Element = Result<(Commit, Tree.Entry), NSError>
    let repo: Repository
    let entry: Tree.Entry
    private var revisionWalker: OpaquePointer?

    private enum Next {
        case over
        case okay
        case error(NSError)

        init(_ result: Int32, name: String) {
            switch result {
            case GIT_ITEROVER.rawValue:
                self = .over
            case GIT_OK.rawValue:
                self = .okay
            default:
//                self = .error(NSError(gitError: result, pointOfFailure: name))
                self = .error(NSError())
            }
        }
    }

    init(repo: Repository, root: git_oid, entry: Tree.Entry) {
        self.repo = repo
        self.entry = entry
        setupRevisionWalker(root: root)
    }

    deinit {
        git_revwalk_free(self.revisionWalker)
    }

    private func setupRevisionWalker(root: git_oid) {
        var oid = root
        git_revwalk_new(&revisionWalker, repo.pointer)
        git_revwalk_sorting(revisionWalker, GIT_SORT_TOPOLOGICAL.rawValue)
        git_revwalk_sorting(revisionWalker, GIT_SORT_TIME.rawValue)
        git_revwalk_push(revisionWalker, &oid)
    }

    public func next() -> Element? {
//        var oid = git_oid()
        var oid = self.entry.object.oid.oid
        let revwalkGitResult = git_revwalk_next(&oid, revisionWalker)
        let nextResult = Next(revwalkGitResult, name: "git_revwalk_next")
        switch nextResult {
        case let .error(error):
            return Result.failure(error)
        case .over:
            return nil
        case .okay:
            var unsafeCommit: OpaquePointer? = nil
            let lookupGitResult = git_commit_lookup(&unsafeCommit, repo.pointer, &oid)
            guard lookupGitResult == GIT_OK.rawValue, let unwrapCommit = unsafeCommit else {
//                return Result.failure(NSError(gitError: lookupGitResult, pointOfFailure: "git_commit_lookup"))
                return Result.failure(NSError())
            }
            
            let unsafeEntry = git_tree_entry_byid(unwrapCommit, &oid)
            guard let unwrapEntry = unsafeEntry else {
                return Result.failure(NSError())
            }
            
            let result: Element = Result.success((Commit(unwrapCommit), Tree.Entry(unwrapEntry)))
            git_commit_free(unsafeCommit)
            return result
        }
    }
}
