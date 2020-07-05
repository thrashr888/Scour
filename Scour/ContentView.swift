//
//  ContentView.swift
//  Scour
//
//  Created by Paul Thrasher on 6/14/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI
import SwiftGit2

struct GitView: View {
    var git: Gitservice
    var currentCommit: Commit?
    var currentBlob: Blob?
    
    init(git: Gitservice) {
        self.git = git
        guard let repo = git.repo else { return }
        currentCommit = repo.latestCommit()
        currentBlob = repo.blob()
    }
    
    var body: some View {
        VStack {
            if git.error() != nil {
                Text("Error: \(git.error()!.localizedDescription)").italic()
            }
            
            if currentCommit != nil {
                Text("Latest Commit: \(currentCommit!.message) by \(currentCommit!.author.name)")
            }
            
            if currentBlob != nil {
                Text("Latest Blob: \(currentBlob!.data)")
            }
        }
    }
}

struct ContentView: View {
    @State var currentUrl: String = "/Users/thrashr888/workspace/Scour"
    //https://github.com/SwiftGit2/SwiftGit2.git
    var git: Gitservice
    
    init(){
        git = Gitservice("/Users/thrashr888/workspace/Scour")
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Git Repo")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.yellow)
                VStack {
                  Text("\(currentUrl)").bold()
                }.frame(maxHeight: 23, alignment: .bottom)
            }.frame(alignment: .leading)
            
            GitView(git: self.git)
        }.frame(width: 800, height: 600, alignment: .leading)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
