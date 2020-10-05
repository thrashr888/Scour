//
//  BranchView.swift
//  Scour
//
//  Created by Paul Thrasher on 10/3/20.
//  Copyright © 2020 Paul Thrasher. All rights reserved.
//

import SwiftUI

struct BranchView: View {
    var branch: BranchModel
    
    @State private var presentingOrderPlacedSheet = false
    @EnvironmentObject private var model: ScourModel
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var selectedCommitID: CommitModel.ID?
    @State private var topmostCommitID: CommitModel.ID?
    @Namespace private var namespace
    
    var bottomBar: some View {
        VStack(spacing: 0) {
            Divider()
            Group {
                Text("PaymentButton()")
//                if let account = model.account, account.canRedeemFreeSmoothie {
//                    RedeemSmoothieButton(action: redeemSmoothie)
//                } else {
//                    PaymentButton(action: orderSmoothie)
//                }
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 16)
        }
        .background(VisualEffectBlur().edgesIgnoringSafeArea(.all))
    }
    
    var body: some View {
        Group {
            Text("body.group")
            container
                .frame(minWidth: 500, idealWidth: 700, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
        }
        .background(Rectangle().fill(BackgroundStyle()).edgesIgnoringSafeArea(.all))
        .navigationTitle(branch.name)
        .toolbar {
            Button(action: {
                presentingOrderPlacedSheet = true
//                repository.fetch()
            }) {
                Text("fetch")
            }
        }
        .sheet(isPresented: $presentingOrderPlacedSheet) {
            VStack(spacing: 0) {
                
                VStack(spacing: 10) {
                    Spacer()
                    Text("fetched \(branch.name)")
                    Spacer()
                }
//                OrderPlacedView()
                
                Divider()
                HStack {
                    Spacer()
                    Button(action: { presentingOrderPlacedSheet = false }) {
                        Text("Done")
                    }
                    .keyboardShortcut(.defaultAction)
                }
                .padding()
                .background(VisualEffectBlur())
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: { presentingOrderPlacedSheet = false }) {
                        Text("Done")
                    }
                }
            }
            .environmentObject(model)
        }
    }
    
    var container: some View {
        ZStack {
            Text("container.zstack")
            ScrollView {
                Text("container.zstack.scrollview")
                content
                    .frame(maxWidth: 600)
                    .frame(maxWidth: .infinity)
            }
            .overlay(bottomBar, alignment: .bottom)

            VisualEffectBlur()
                .edgesIgnoringSafeArea(.all)
                .opacity(1)
            
            ForEach(branch.commits, id: \.id) { commit in
                Text("container.zstack.branch")
                let presenting = selectedCommitID == commit.id
                Text("\(commit.id) CommitCard(commit: commit)")
//                BranchCard(branch: branch.ingredient, presenting: presenting, closeAction: deselectBranch)
//                    .matchedGeometryEffect(id: branch.id, in: namespace, isSource: presenting)
//                    .aspectRatio(0.75, contentMode: .fit)
//                    .shadow(color: Color.black.opacity(presenting ? 0.2 : 0), radius: 20, y: 10)
//                    .padding(20)
//                    .opacity(presenting ? 1 : 0)
//                    .zIndex(topmostBranchID == branch.id ? 1 : 0)
//                    .accessibilityElement(children: .contain)
//                    .accessibility(sortPriority: presenting ? 1 : 0)
//                    .accessibility(hidden: !presenting)
            }
        }
    }
    
    var content: some View {
        VStack(spacing: 0) {
            Text("content.vstack")
            Text("BranchHeaderView(branch: branch)")
//            BranchHeaderView(branch: branch)
                
            VStack(alignment: .leading) {
                Text("Commits")
                    .font(Font.title).bold()
                    .foregroundColor(.secondary)
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 130), spacing: 16, alignment: .top)], alignment: .center, spacing: 16) {
                    ForEach(branch.commits, id: \.id) { commit in
                        let ingredient = commit
                        let presenting = selectedCommitID == commit.id
                        Button(action: { select(commit: commit) }) {
                            Text("\(commit.id) CommitGraphic(commit: commit)")
//                            CommitGraphic(commit: commit, style: presenting ? .cardFront : .thumbnail)
//                                .matchedGeometryEffect(
//                                    id: commit.id,
//                                    in: namespace,
//                                    isSource: !presenting
//                                )
//                                .contentShape(Rectangle())
                        }
                        .buttonStyle(SquishableButtonStyle(fadeOnPress: false))
                        .aspectRatio(1, contentMode: .fit)
                        .zIndex(topmostCommitID == commit.id ? 1 : 0)
                        .accessibility(label: Text("\(commit.id) Branch"))
                    }
                }
            }
            .padding()
        }
        .padding(.bottom, 90)
        .onAppear {
            branch.load()
        }
    }
    
    func select(commit: CommitModel) {
        topmostCommitID = commit.id
        withAnimation(.openCard) {
            selectedCommitID = commit.id
        }
    }
    
    func deselectCommit() {
        withAnimation(.closeCard) {
            selectedCommitID = nil
        }
    }
}

//struct SmoothieView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            NavigationView {
//                SmoothieView(smoothie: .berryBlue)
//            }
//
//            ForEach([Smoothie.thatsBerryBananas, .oneInAMelon, .berryBlue]) { smoothie in
//                SmoothieView(smoothie: smoothie)
//                    .previewLayout(.sizeThatFits)
//                    .frame(height: 700)
//            }
//        }
//        .environmentObject(FrutaModel())
//    }
//}
