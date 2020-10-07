//
//  RepoMenu.swift
//  Scour
//
//  Created by Paul Thrasher on 9/27/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

struct RepositoryMenu: View {
    var model: ScourModel
    
    var body: some View {
        RepositoryList(repositories: model.repositories)
            .navigationTitle("Repositories")
    }
    
}

struct RepositoryMenu_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryMenu(model: ScourModel())
    }
}
