//
//  SquishableButtonStyle.swift
//  Scour
//
//  Created by Paul Thrasher on 9/28/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

struct SquishableButtonStyle: ButtonStyle {
    var fadeOnPress = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed && fadeOnPress ? 0.75 : 1)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
