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
                Text(repository.name)
                    .font(.headline)
                    .lineLimit(1)
                
//                Text(repository)
//                    .lineLimit(2)
//                    .accessibility(label: Text("Ingredients: \(ingredients)."))
//
//                Text("\(smoothie.kilocalories) Calories")
//                    .foregroundColor(.secondary)
//                    .lineLimit(1)
            }
            
            Spacer(minLength: 0)
        }
        .font(.subheadline)
        .padding(.vertical, 10)
        .accessibilityElement(children: .combine)
    }
}
