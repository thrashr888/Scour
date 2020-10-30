//
//  AppView.swift
//  Scour
//
//  Created by Paul Thrasher on 10/29/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

struct AppView: View {

    @EnvironmentObject private var model: ScourModel
    
    var body: some View {
        RepositoryMenu(model: model)
    }
    
}
