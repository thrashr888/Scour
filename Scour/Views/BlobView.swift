//
//  BlobView.swift
//  Scour
//
//  Created by Paul Thrasher on 7/5/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import AppKit
import SwiftUI
import SwiftGit2
import Down

struct BlobView: View {
    var blob: Blob
    var name: String
    var content: String?
    var downView: DownView?
    var attributedStr: NSAttributedString?
    var isMarkdown = false
    
    init(blob: Blob, name: String){
        self.blob = blob
        self.name = name
        
        self.content = String(data: blob.data, encoding: .utf8)

//        if name.hasSuffix(".md") {
//            attributedStr = try? Down(markdownString: self.content!).toAttributedString()
//        }
    }
    
    var body: some View {
//        Text(blob.data.description)
        VStack(alignment: .leading) {
            ScrollView([.vertical]) {
                if content != nil {
                    if attributedStr != nil {
                        TextView(text: self.attributedStr!)
                    } else {
//                        Text(content!)
                        TextField("", text: .constant(content!))
                    }
                } else {
                    Text("Cannot read file: \(name)")
                }
            }
        }
    }
}

struct TextView: NSViewRepresentable {
  typealias NSViewType = NSTextView

  var text: NSAttributedString

  func makeNSView(context: Context) -> NSTextView {
    let view = NSTextView()
    // set background color to show view bounds
    view.backgroundColor = NSColor.init(calibratedRed: 60, green: 60, blue: 61, alpha: 0)
    view.drawsBackground = true
    view.isEditable = false
    view.isSelectable = true
    view.isRulerVisible = true
    return view
  }

  func updateNSView(_ nsView: NSTextView, context: Context) {
    nsView.textStorage?.setAttributedString(text)
  }
}

struct BlobView_Previews: PreviewProvider {
    static var previews: some View {
//        BlobView(Blob(""), "test.md")
        TextField("", text: .constant("test"))
    }
}
