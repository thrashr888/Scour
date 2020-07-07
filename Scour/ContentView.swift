//
//  ContentView.swift
//  Scour
//
//  Created by Paul Thrasher on 6/14/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI
import SwiftGit2

struct RepoWrapperView: View {
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

struct ContentView: View {
    @State var currentUrl: String = "/Users/thrashr888/workspace/Scour"
    // https://github.com/SwiftGit2/SwiftGit2.git

    var body: some View {
        HStack {
            VStack {
                HStack {
                    TextField("Path", text: self.$currentUrl)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding([.top, .leading, .trailing])
                
                Divider()
                RepoWrapperView(self.currentUrl)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        }.frame(width: 800, height: 600)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
