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
        
        if name.hasSuffix(".md") {
            self.isMarkdown = true
        }
        
        self.content = String(data: blob.data, encoding: .utf8)
        
        if isMarkdown {
            let downMdStr = Down(markdownString: self.content!)
            attributedStr = try? downMdStr.toAttributedString()
        }
    }
    
    var body: some View {
//        Text(blob.data.description)
        VStack(alignment: .leading) {
            Group {
                if content != nil {
                    if isMarkdown {
                        Label {
                            $0.placeholderAttributedString = self.attributedStr!
                        }
                    } else {
                        Text(content!)
                    }
                } else {
                    Text("Cannot read this file")
                }
            }
        }
    }
}

struct Label: NSViewRepresentable {
    typealias NSViewType = NSTextField
    fileprivate var configuration = { (view: NSViewType) in }

    func makeNSView(context: NSViewRepresentableContext<Self>) -> NSViewType { NSViewType() }
    func updateNSView(_ uiView: NSViewType, context: NSViewRepresentableContext<Self>) {
        configuration(uiView)
    }
}

//struct BlobView_Previews: PreviewProvider {
//    static var previews: some View {
//        BlobView()
//    }
//}
