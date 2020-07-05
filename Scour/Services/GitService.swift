//
//  GitService.swift
//  Scour
//
//  Created by Paul Thrasher on 7/4/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import Foundation
import SwiftGit2

class Reposervice : ObservableObject {
    @Published var lastError: Error?
    @Published var lastCommit: Error?
    
    var url: URL
    var repo: Repository
    var currentOID: OID? = nil
    
    init(url: URL, repo: Repository) {
        self.url = url
        self.repo = repo
    }
    
    func head() -> OID? {
        let result = repo.HEAD().map {
            $0.oid
        }
        switch result {
        case let .success(latestOID):
            self.currentOID = latestOID
            return latestOID
        case let .failure(error):
            self.lastError = error
            return nil
        }
    }
    
    func tree() -> Tree? {
        let res = repo.tree(self.currentOID!)
        
        switch res {
        case let .success(obj):
            return obj
        case let .failure(error):
            self.lastError = error
            return nil
        }
    }
    
    func commits() -> Commit? {
        let res = repo.HEAD().flatMap {
            repo.commit($0.oid)
        }
        
        switch res {
        case let .success(obj):
            return obj
        case let .failure(error):
            self.lastError = error
            return nil
        }
    }
    
    func latestCommit() -> Commit? {
        let res = repo.HEAD().flatMap {
            repo.commit($0.oid)
        }
        
        switch res {
        case let .success(obj):
            return obj
        case let .failure(error):
            self.lastError = error
            return nil
        }
    }
    
    func blob() -> Blob? {
//        return repo!.blob(self.currentOID!)

        let res = repo.HEAD().flatMap {
            repo.blob($0.oid)
        }
        
        switch res {
        case let .success(obj):
            return obj
        case let .failure(error):
            self.lastError = error
            return nil
        }
    }
}

class Gitservice : ObservableObject {
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
            self.lastError = error
        }
    }
    
    func error() -> Error? {
        if (self.lastError != nil) {
            return self.lastError
        } else if ((self.repo?.lastError) != nil) {
            return self.repo?.lastError
        }
        return nil
    }
}

extension DateFormatter {
  static let iso8601Full: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
}
