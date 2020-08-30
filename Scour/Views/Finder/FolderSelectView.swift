//
//  FoldersView.swift
//  Scour
//
//  Created by Paul Thrasher on 7/23/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftGit2
import SwiftUI

struct FolderSelectView: View {
    // internal
    @State var urls: [URL] = []

    // bound
    @Binding var currentUrl: URL?

    func addUrl() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.begin { response in
            if response == NSApplication.ModalResponse.OK, let fileUrl = panel.url {
                self.urls.append(fileUrl)
                _ = UrlsPlist.insert(url: fileUrl)
            }
        }
    }

    func loadFolders() {
        urls = UrlsPlist.index()
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Add folder", action: addUrl)
            }
            .padding(.top)
            .padding(.leading, 5.0)

            List(self.urls, id: \.self, selection: $currentUrl) { url in
                Text(url.relativePath)
                    .truncationMode(.head)
            }
            .onAppear(perform: loadFolders)
        }
    }
}

struct FoldersView_Previews: PreviewProvider {
    static var previews: some View {
        FolderSelectView(currentUrl: .constant(URL(fileURLWithPath: "/Users/thrashr888/workspace/Bookworm")))
    }
}
