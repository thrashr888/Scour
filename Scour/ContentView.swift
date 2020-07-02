//
//  ContentView.swift
//  Scour
//
//  Created by Paul Thrasher on 6/14/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI
import SwiftGit2



func loadRepo(path: String = "") {
    let url: URL = URL(fileURLWithPath: path)
    let result = Repository.at(url)
    
    switch result {
    case let .success(repo):
        let latestCommit = repo
            .HEAD()
            .flatMap {
                repo.commit($0.oid)
            }

        switch latestCommit {
        case let .success(commit):
            print("Latest Commit: \(commit.message) by \(commit.author.name)")

        case let .failure(error):
            print("Could not get commit: \(error)")
        }

    case let .failure(error):
        print("Could not open repository: \(error)")
    }
}


struct ContentView: View {
    init(){
        loadRepo(path: "/Users/thrashr888/hashicorp/atlas")
//        loadRepo(url: "https://github.com/SwiftGit2/SwiftGit2.git")
    }
    
    var body: some View {
        Text("Hello, /Users/thrashr888/hashicorp/atlas!")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
