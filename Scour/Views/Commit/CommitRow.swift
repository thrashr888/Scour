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
                        .lineLimit(1)
                    Spacer()
                    Text("\(commit.createdAt, formatter: Self.taskDateFormat)")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text(commit.name)
                        .foregroundColor(.secondary)
                        .font(.body)
                    Text(commit.description)
                        .font(.body)
                        .lineLimit(1)
                    Spacer()
                    Label("", systemImage: "circlebadge.fill")
                        .multilineTextAlignment(.trailing)
                }
            }
            
            Spacer(minLength: 0)
        }
        .padding(.vertical, 10)
        .accessibilityElement(children: .combine)
    }
}
