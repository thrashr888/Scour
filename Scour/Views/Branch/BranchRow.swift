//
//  BranchRow.swift
//  Scour
//
//  Created by Paul Thrasher on 10/3/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

struct BranchRow: View {
    var branch: BranchModel
    
    @EnvironmentObject private var model: ScourModel
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Label(branch.name, systemImage: "arrow.triangle.branch")
                    .font(.headline)
                    .lineLimit(1)
                Text(branch.description)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer(minLength: 0)
        }
        .padding(.vertical, 10)
        .accessibilityElement(children: .combine)
    }
}
