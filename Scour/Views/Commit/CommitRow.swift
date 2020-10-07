//
//  CommitRow.swift
//  Scour
//
//  Created by Paul Thrasher on 10/6/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

struct CommitRow: View {
    var commit: CommitModel
    
    @EnvironmentObject private var model: ScourModel
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                
                HStack(alignment: .lastTextBaseline) {
                    Text(commit.authorName)
                        .foregroundColor(Color.orange).truncationMode(.tail)
                    Text("\(commit.committerTime, formatter: Self.taskDateFormat)").multilineTextAlignment(.trailing)
                    Spacer()
                    Text(commit.oidDescription).frame(width: 60.0, height: 13.0).truncationMode(.tail)
                }
                HStack {
                    Text(commit.message).frame(height: 13.0).truncationMode(.tail)
                }
                
                Text("\(String(commit.treeOidDescription.prefix(6)))")
                Text("\(commit.name)")
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
