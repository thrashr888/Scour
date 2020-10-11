//
//  EntryView.swift
//  Scour
//
//  Created by Paul Thrasher on 7/5/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import Clibgit2
import SwiftGit2
import SwiftUI

struct NewEntryView: View {
    var entryModel: OldEntryModel

    init(commitsModel: CommitsModel, entry: Tree.Entry) {
        entryModel = OldEntryModel(commitsModel: commitsModel, entry: entry)
    }

    var body: some View {
        VStack(alignment: .leading) {
            if entryModel.isBlob {
                Text("\(entryModel.entry.name)")
                    .fontWeight(.bold)
                    .padding(.horizontal)
            }

            if entryModel.blob != nil {
//                BlobView(blob: entryModel.blob!, name: entryModel.entry.name)
            } else {
                Text("Loading...")
            }
        }
        .padding(.top)
    }
}

// struct NewEntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        EntryView()
//    }
// }
