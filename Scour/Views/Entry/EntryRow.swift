//
//  EntryRow.swift
//  Scour
//
//  Created by Paul Thrasher on 10/6/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

struct EntryRow: View {
    var entry: EntryModel
    
    @EnvironmentObject private var model: ScourModel
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Label(entry.name, systemImage: entry.isTree ? "folder" : "doc")
                    .font(.headline)
                    .lineLimit(1)
            }
            
            Spacer(minLength: 0)
        }
        .font(.subheadline)
        .padding(.vertical, 10)
        .accessibilityElement(children: .combine)
    }
}
