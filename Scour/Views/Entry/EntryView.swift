//
//  EntryView.swift
//  Scour
//
//  Created by Paul Thrasher on 10/6/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

struct EntryView: View {
    @ObservedObject var entry: EntryModel
    
    @EnvironmentObject private var model: ScourModel
    
    @State var loading = false
    
    var body: some View {
        Group {
            CommitLine(entry: entry, commits: entry.commits)
                .onAppear {
                    entry.loadCommits()
                }
            
            Label(entry.fullPath, systemImage: entry.isTree ? "folder" : "doc")
                .font(.headline)
                .padding(.top, 5)
        
            if entry.blob != nil && !loading {
                BlobView(model: entry.blob!, name: entry.name)
            } else {
                ProgressView()
                    .onAppear {
                        loading = true
                        DispatchQueue.main.async {
                            entry.loadBlob()
                            loading = false
                        }
                    }
            }
        }
//        .background(Rectangle().fill(BackgroundStyle()).edgesIgnoringSafeArea(.all))
        .navigationTitle(entry.name)
    }
}
