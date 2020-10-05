//
//  BranchMenu.swift
//  Scour
//
//  Created by Paul Thrasher on 10/3/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import Foundation
import SwiftUI

struct BranchMenu: View {
    var model: RepositoryModel
    
    var body: some View {
        BranchList(branches: model.branches)
            .navigationTitle("Branches")
    }
    
}

//struct BranchMenu_Previews: PreviewProvider {
//    static var previews: some View {
//        BranchMenu(model: ScourModel())
//    }
//}
