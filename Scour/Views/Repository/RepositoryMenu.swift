//
//  RepoMenu.swift
//  Scour
//
//  Created by Paul Thrasher on 9/27/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

struct RepositoryMenu: View {
    @ObservedObject var model: ScourModel
    
    func addUrl() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.begin { response in
            if response == NSApplication.ModalResponse.OK, let url = panel.url {
                model.addRepository(url)
            }
        }
    }

    var body: some View {
        RepositoryList(repositories: model.repositories, addUrl: addUrl)
            .navigationTitle("Repositories")
            .onAppear {
                model.load()
            }
    }
    
}

struct RepositoryMenu_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryMenu(model: ScourModel())
    }
}
