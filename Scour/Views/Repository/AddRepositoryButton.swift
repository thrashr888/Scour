//
//  AddRepositoryButton.swift
//  Scour
//
//  Created by Paul Thrasher on 10/9/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI
import StoreKit

struct AddRepositoryButton: View {
    var action: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    var bar: some View {
        HStack {
            Spacer()
            Button("Add Repository", action: action)
                .buttonStyle(BorderedButtonStyle())
                .accessibility(label: Text("Add Repository"))
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }
    
    var shape: RoundedRectangle {
        return RoundedRectangle(cornerRadius: 10, style: .continuous)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            bar.background(Rectangle().fill(BackgroundStyle()))
        }
        .clipShape(shape)
        .overlay(shape.inset(by: 0.5).stroke(Color.primary.opacity(0.1), lineWidth: 1))
        .accessibilityElement(children: .contain)
    }
}

// MARK: - Previews
struct AddRepositoryButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddRepositoryButton(action: {})
        }
        .frame(width: 300)
        .previewLayout(.sizeThatFits)
    }
}
