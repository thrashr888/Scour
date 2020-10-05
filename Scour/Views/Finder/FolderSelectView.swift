//
//  FoldersView.swift
//  Scour
//
//  Created by Paul Thrasher on 7/23/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftGit2
import SwiftUI

struct Tooltip: NSViewRepresentable {
    let tooltip: String
    func makeNSView(context _: NSViewRepresentableContext<Tooltip>) -> NSView {
        let view = NSView()
        view.toolTip = tooltip
        return view
    }

    func updateNSView(_: NSView, context _: NSViewRepresentableContext<Tooltip>) {}
}

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
                _ = UrlStore.insert(url: fileUrl)
            }
        }
    }

    func loadFolders() {
        urls = UrlStore.index()
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
                Text(url.lastPathComponent).tag(url).truncationMode(.tail)
                    .overlay(Tooltip(tooltip: url.relativePath))
            }
            .listStyle(SidebarListStyle())
            .onAppear(perform: loadFolders)
        }
    }
}

struct FoldersView_Previews: PreviewProvider {
    static var previews: some View {
        FolderSelectView(currentUrl: .constant(URL(fileURLWithPath: "/Users/thrashr888/workspace/Bookworm")))
    }
}
