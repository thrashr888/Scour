//
//  CommitLine.swift
//  Scour
//
//  Created by Paul Thrasher on 10/18/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

struct CommitLine: View {
    var entry: EntryModel
    var commits: [CommitEntryPairModel] = []
    
    @State private var selection: (CommitModel, EntryModel)?
    @EnvironmentObject private var model: ScourModel
    
    var showLoading: some View {
        ProgressView().padding()
    }
    
    var body: some View {
        VStack {
            Text("Commit dots:")
            
            HStack {
                ForEach(commits) { pair in
                    Button(action: {
                        print(pair.commit.id, pair.entry.id)
                    }) {
                        Label(pair.commit.name, systemImage: "circle")
                    }
                    .accessibility(label: Text(pair.entry.name))
                }
                .overlay(entry.loading ? showLoading : nil, alignment: .bottom)
                
                if entry.more && !entry.loading {
                    Button(action: {
                        entry.loadCommits()
                    }) {
                        Text("Load more")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(VisualEffectBlur().edgesIgnoringSafeArea(.all))
        //                            .background(Color.accentColor)
                    }.buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}
