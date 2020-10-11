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
    
    var body: some View {
        Group {            
            if entry.blob != nil {
                BlobView(blob: entry.blob!, name: entry.name)
            } else {
                ProgressView()
                    .onAppear {
                        entry.loadBlob()
                    }
            }
        }
        .background(Rectangle().fill(BackgroundStyle()).edgesIgnoringSafeArea(.all))
        .navigationTitle(entry.name)
    }
}
