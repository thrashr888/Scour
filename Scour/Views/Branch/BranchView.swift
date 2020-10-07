//
//  BranchView.swift
//  Scour
//
//  Created by Paul Thrasher on 10/3/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

struct BranchView: View {
    var branch: BranchModel
    
    @State private var presentingOrderPlacedSheet = false
    @EnvironmentObject private var model: ScourModel
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var selectedCommitID: CommitModel.ID?
    @State private var topmostCommitID: CommitModel.ID?
    @Namespace private var namespace
    
    var body: some View {
        Group {
            Text("branch.body.group")
        }
        .background(Rectangle().fill(BackgroundStyle()).edgesIgnoringSafeArea(.all))
        .navigationTitle(branch.name)
    }
}

//struct SmoothieView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            NavigationView {
//                SmoothieView(smoothie: .berryBlue)
//            }
//
//            ForEach([Smoothie.thatsBerryBananas, .oneInAMelon, .berryBlue]) { smoothie in
//                SmoothieView(smoothie: smoothie)
//                    .previewLayout(.sizeThatFits)
//                    .frame(height: 700)
//            }
//        }
//        .environmentObject(FrutaModel())
//    }
//}
