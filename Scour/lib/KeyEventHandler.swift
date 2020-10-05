//
//  KeyEventHandler.swift
//  Scour
//
//  Created by Paul Thrasher on 9/23/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

struct KeyEventHandler: NSViewRepresentable {
    var callback: (NSEvent) -> Void

    class KeyView: NSView {
        var callback: ((NSEvent) -> Void)?
        override var acceptsFirstResponder: Bool { true }
        override func keyDown(with event: NSEvent) {
            super.keyDown(with: event)
//            print(">> key \(event.charactersIgnoringModifiers ?? "")")
            callback!(event)
        }
    }

    func makeNSView(context _: Context) -> NSView {
        let view = KeyView()
        view.callback = callback
        DispatchQueue.main.async { // wait till next event cycle
            view.window?.makeFirstResponder(view)
        }
        return view
    }

    func updateNSView(_: NSView, context _: Context) {}
}
