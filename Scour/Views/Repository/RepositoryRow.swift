//
//  RepoRow.swift
//  Scour
//
//  Created by Paul Thrasher on 9/28/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

struct RepositoryRow: View {
    var repository: RepositoryModel
    
    @EnvironmentObject private var model: ScourModel
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Label(repository.name, systemImage: "folder")
                    .font(.headline)
                    .lineLimit(1)
                Text(repository.description)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer(minLength: 0)
        }
        .padding(.vertical, 10)
        .accessibilityElement(children: .combine)
    }
}
