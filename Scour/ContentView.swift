//
//  ContentView.swift
//  Scour
//
//  Created by Paul Thrasher on 6/14/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI
import SwiftGit2

struct PresentableEntry: Equatable, Identifiable {
    let id = UUID()
    let entry: Tree.Entry
    let blob: Blob?
    
    static func == (lhs: PresentableEntry, rhs: PresentableEntry) -> Bool {
        lhs.id == rhs.id
    }
}

struct CurrentEntryPreferenceKey: PreferenceKey {
    static var defaultValue: PresentableEntry?
    static func reduce(value: inout PresentableEntry?, nextValue: () -> PresentableEntry?) {
        value = nextValue()
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

                GitView(self.currentUrl)
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
