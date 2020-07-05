//
//  GitService.swift
//  Scour
//
//  Created by Paul Thrasher on 7/4/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import Foundation
import SwiftGit2

#if DEBUG
//    let API_BASE_URL = "https://travelwithluna.com"
    let API_BASE_URL = "http://127.0.0.1:80"
#else
    let API_BASE_URL = "http://127.0.0.1:80"
#endif

struct APIRequest: Encodable {}
struct APIResponse: Decodable {
    var error: String?
    var statusCode: Int?
}

class Gitservice : ObservableObject {
    @Published var lastError: Error?
    @Published var lastCommit: Error?
    
    var url: URL?
    var repo: Repository? = nil
    var currentOID: OID? = nil
    
    func boot(path: String) {
        self.url = self.setUrl(path: path)
        self.repo = self.loadRepo()
    }
    
    func setUrl(path: String) -> URL {
        return URL(fileURLWithPath: path)
    }
    
    func loadRepo() -> Repository? {
        let res = Repository.at(url!)
        switch res {
        case let .success(obj):
            return obj
        case let .failure(error):
            self.lastError = error
            return nil
        }
    }
    
    func getHead() -> OID? {
        guard repo != nil else { return nil }
        let result = repo!.HEAD().map {
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
    
    func getTree() -> Tree? {
        guard repo != nil else { return nil }

        let res = repo!.tree(self.currentOID!)
        
        switch res {
        case let .success(obj):
            return obj
        case let .failure(error):
            self.lastError = error
            return nil
        }
    }
    
    func getCommits() -> Commit? {
        guard repo != nil else { return nil }

        let res = repo!.HEAD().flatMap {
            repo!.commit($0.oid)
        }
        
        switch res {
        case let .success(obj):
            return obj
        case let .failure(error):
            self.lastError = error
            return nil
        }
    }
    
    func getLatestCommit() -> Commit? {
        guard repo != nil else { return nil }

        let res = repo!.HEAD().flatMap {
            repo!.commit($0.oid)
        }
        
        switch res {
        case let .success(obj):
            return obj
        case let .failure(error):
            self.lastError = error
            return nil
        }
    }
    
    func getBlob() -> Blob? {
        guard repo != nil else { return nil }

        let res = repo!.HEAD().flatMap {
            repo!.blob($0.oid)
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
