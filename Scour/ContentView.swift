//
//  ContentView.swift
//  Scour
//
//  Created by Paul Thrasher on 6/14/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import Carbon.HIToolbox.Events
import SwiftGit2
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

struct SummaryView: View {
    @ObservedObject var commitsModel: CommitsModel

    var body: some View {
        HStack {
            if commitsModel.commit != nil {
                Text("\(commitsModel.repoName!)#\(commitsModel.branch!.name)@\(String(commitsModel.commit!.tree.oid.description.prefix(6)))/\(commitsModel.entry?.name ?? "")")

            } else if commitsModel.branch != nil {
                Text("\(commitsModel.repoName!)#\(commitsModel.branch!.name)")

            } else if commitsModel.repoName != nil {
                Text("\(commitsModel.repoName!)")
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject var commitsModel = CommitsModel()

    @State var entry: Tree.Entry? = nil

    func prevCommit() {
        commitsModel.prevCommit()
    }

    func nextCommit() {
        commitsModel.nextCommit()
    }

    func onKeyEvent(event: NSEvent) {
        if event.keyCode == kVK_LeftArrow || event.keyCode == kVK_ANSI_Comma {
            commitsModel.prevCommit()
        } else
        if event.keyCode == kVK_RightArrow || event.keyCode == kVK_ANSI_Period {
            commitsModel.nextCommit()
        }
    }

    var body: some View {
        HStack {
            HStack {
                FinderView(entry: $entry, commitsModel: commitsModel)
                    .frame(minWidth: 200, maxWidth: 300, minHeight: 300, maxHeight: .infinity)
                    .padding(.trailing)

                VStack {
                    SummaryView(commitsModel: commitsModel)

                    if commitsModel.commit != nil {
                        HStack {
                            CommitsLineView(entry: $entry, commitsModel: commitsModel)
                            Button("<", action: prevCommit)
                            Button(">", action: nextCommit)
                        }
                        .padding(.top, 8.0)
                        .padding(.trailing, 5.0)

                        CommitSelectSingleView(commit: commitsModel.commit!)
                            .padding(.trailing, 5.0)
                            .background(KeyEventHandler(callback: onKeyEvent))

                        Divider()
                    }

                    if commitsModel.repoUrl != nil && commitsModel.entry != nil {
                        NewEntryView(commitsModel: commitsModel, entry: commitsModel.entry!)
                            .frame(minWidth: 300, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
                    } else {
                        Text(" ")
                            .frame(minWidth: 300, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
