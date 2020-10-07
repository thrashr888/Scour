//
//  BranchList.swift
//  Scour
//
//  Created by Paul Thrasher on 10/3/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

struct BranchList: View {
    var branches: [BranchModel]
    
    @State private var selection: BranchModel?
    @EnvironmentObject private var model: ScourModel
    
    var body: some View {
        List(selection: $selection) {
            ForEach(branches) { branch in
                NavigationLink(
                    destination: CommitMenu(model: branch).environmentObject(model),
                    tag: branch,
                    selection: $selection
                ) {
                    BranchRow(branch: branch)
                }
                .tag(branch)
            }
        }
    }
}

//struct BranchList_Previews: PreviewProvider {
//    static var previews: some View {
//        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
//            NavigationView {
//                BranchList(branches: Branch.all)
//                    .navigationTitle("Branches")
//                    .environmentObject(ScourModel())
//            }
//            .preferredColorScheme(scheme)
//        }
//    }
//}
