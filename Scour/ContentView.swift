//
//  ContentView.swift
//  Scour
//
//  Created by Paul Thrasher on 6/14/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI
import SwiftGit2

struct TitleView: View {
    var currentUrl: String
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Git Repo")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(.yellow)
            Spacer()
            Text("\(currentUrl)").bold()
        }.frame(alignment: .leading)
    }
}

struct ErrorView: View {
    var error: Error
    var body: some View {
        VStack(alignment: .leading) {
            Text("Error").font(.subheadline).bold()
            Text(" \(error.localizedDescription)").italic()
        }
        .padding(.all)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
        .background(/*@START_MENU_TOKEN@*/Color.red/*@END_MENU_TOKEN@*/.opacity(0.3))
        .border(/*@START_MENU_TOKEN@*/Color.red/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
    }
}

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
                ErrorView(error: git.error()!)
            }
            
            if currentCommit != nil {
                Text("Latest Commit: \(currentCommit!.oid.description)\n \(currentCommit!.message)\n by \(currentCommit!.author.name)")
                    .padding(.top)
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
        HStack {
            VStack {
                TitleView(currentUrl: currentUrl)
                    .padding([.top, .leading, .trailing])
                Divider()
                GitView(git: self.git)
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
