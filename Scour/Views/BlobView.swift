//
//  BlobView.swift
//  Scour
//
//  Created by Paul Thrasher on 7/5/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI
import SwiftGit2

struct BlobView: View {
    var blob: Blob
    var content: String?
    init(blob: Blob){
        self.blob = blob
        self.content = String(data: blob.data, encoding: .utf8)
    }
    
    var body: some View {
//        Text(blob.data.description)
        VStack(alignment: .leading) {
            if content != nil {
                Text(content!)
            }
        }
    }
}

//struct BlobView_Previews: PreviewProvider {
//    static var previews: some View {
//        BlobView()
//    }
//}
