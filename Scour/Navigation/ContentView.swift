//
//  ContentView.swift
//  Scour
//
//  Created by Paul Thrasher on 6/14/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftGit2
import SwiftUI

struct ContentView: View {
    @ObservedObject var store: ScourModel
    @ObservedObject var commitsModel: CommitsModel

    @State var entry: Tree.Entry? = nil

    var body: some View {
        AppSidebarNavigation()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: ScourModel(), commitsModel: CommitsModel())
    }
}
