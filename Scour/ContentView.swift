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
    @State var currentUrl: URL = URL(fileURLWithPath: "/Users/thrashr888/workspace/Scour")
    // https://github.com/SwiftGit2/SwiftGit2.git

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Button("Choose folder") {
                        let panel = NSOpenPanel()
                        panel.allowsMultipleSelection = false
                        panel.canChooseFiles = false
                        panel.canChooseDirectories = true
                        panel.begin { response in
                            if response == NSApplication.ModalResponse.OK, let fileUrl = panel.url {
                                self.currentUrl = fileUrl
                                print(fileUrl)
                            }
                        }
                    }
                    
                    Text(self.currentUrl.path)
                        .padding(.horizontal, 10.0).padding(.vertical, 7.0)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading).background(Color.black)
                        .border(Color.gray, width: 2)
                }
                .padding([.top, .leading, .trailing])
                
                Divider()
                    .padding(.top, 2.0)

                GitView(url: self.currentUrl)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
