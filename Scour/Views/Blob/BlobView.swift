//
//  BlobView.swift
//  Scour
//
//  Created by Paul Thrasher on 7/5/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import AppKit
import Down
import SwiftGit2
import SwiftUI

struct BlobView: View {
    var model: BlobModel
    var name: String
    var downView: DownView?
    
    @State var renderMarkdown = false

    var body: some View {
        VStack(alignment: .leading) {
            if model.error != nil {
                ErrorView(error: model.error!)
            }
            ScrollView([.vertical]) {
                if model.content != nil {
                    if model.attributedStr != nil && renderMarkdown {
                        TextView(text: model.attributedStr!)
                    } else {
                        TextEditor(text: .constant(model.content!))
                            .padding(2)
//                        TextField("", text: .constant(model.content!))
//                            .padding(2)
                    }
                } else {
                    Text("Cannot read file: \(name)")
                }
            }
            .toolbar {
                if model.isMarkdown{
                    Form {
                        Toggle("Render Markdown", isOn: $renderMarkdown)
                    }
                }
            }
        }
    }
}

struct TextView: NSViewRepresentable {
    typealias NSViewType = NSTextView

    var text: NSAttributedString

    func makeNSView(context _: Context) -> NSTextView {
        let view = NSTextView()
        // set background color to show view bounds
        view.backgroundColor = NSColor(calibratedRed: 60, green: 60, blue: 61, alpha: 0)
        view.drawsBackground = true
        view.isEditable = false
        view.isSelectable = true
        view.isRulerVisible = true
        return view
    }

    func updateNSView(_ nsView: NSTextView, context _: Context) {
        nsView.textStorage?.setAttributedString(text)
    }
}

struct BlobView_Previews: PreviewProvider {
    static var previews: some View {
//        BlobView(Blob(""), "test.md")
        TextField("", text: .constant("test"))
    }
}
