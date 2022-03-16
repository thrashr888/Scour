//
//  Animations.swift
//  Scour
//
//  Created by Paul Thrasher on 9/28/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

extension Animation {
    static let openCard = Animation.spring(response: 0.45, dampingFraction: 0.9)
    static let closeCard = Animation.spring(response: 0.35, dampingFraction: 1)
    static let flipCard = Animation.spring(response: 0.35, dampingFraction: 0.7)
}
