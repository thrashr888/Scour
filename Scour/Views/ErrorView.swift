//
//  ErrorView.swift
//  Scour
//
//  Created by Paul Thrasher on 7/5/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

struct ErrorView: View {
    var error: Error
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Error")
                .font(.subheadline)
                .bold()
            Text(" \(error.localizedDescription)")
                .italic()
        }
        .padding(.all)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
        .background(/*@START_MENU_TOKEN@*/Color.red/*@END_MENU_TOKEN@*/ .opacity(0.3))
        .border(/*@START_MENU_TOKEN@*/Color.red/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
    }
}

struct CustomError: LocalizedError {
    var title: String
    init(title: String? = "") {
        self.title = title ?? "Error"
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: CustomError())
    }
}
