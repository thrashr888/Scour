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
                HStack {
                    Text(commit.authorName)
                        .foregroundColor(.secondary)
                        .accessibility(label: Text("\(commit.authorName)"))
                    Spacer()
                    Text("\(commit.committerTime, formatter: Self.taskDateFormat)")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.trailing)
                }
                
                HStack {
                    Label(commit.treeOidDescription.prefix(6), systemImage: "circlebadge.fill")
                        .font(.body)
//                    Text("\(String(commit.treeOidDescription.prefix(6)))")
//                        .font(.body)
//                        .foregroundColor(.secondary)
                    Text(commit.message)
                        .font(.body)
                        .lineLimit(1)
                }
            }
            
            Spacer(minLength: 0)
        }
        .padding(.vertical, 10)
        .accessibilityElement(children: .combine)
    }
}
