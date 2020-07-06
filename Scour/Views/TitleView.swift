//
//  TitleView.swift
//  Scour
//
//  Created by Paul Thrasher on 7/5/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

struct TitleView: View {
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Git Repo")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(.yellow)
            Spacer()
        }.frame(alignment: .leading)
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
