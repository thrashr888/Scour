//
//  GitView.swift
//  Scour
//
//  Created by Paul Thrasher on 7/8/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI
import SwiftGit2

struct GitView: View {
    var repo: Repository?
    var error: Error?
    
    init(_ path: String) {
        let url = URL(fileURLWithPath: path)

        switch Repository.at(url) {
        case let .success(repo):
            self.repo = repo
        case let .failure(error):
            self.error = error
        }
    }
    
    var body: some View {
        VStack {
            if self.repo != nil {
                RepoView(self.repo!)
            }
            if self.error != nil {
                ErrorView(error: self.error!)
            }
        }
    }
}

struct GitView_Previews: PreviewProvider {
    static var previews: some View {
        GitView("/Users/thrashr888/workspace/Scour")
    }
}
