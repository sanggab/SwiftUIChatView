//
//  ChatGifView.swift
//  SwiftUIChatView
//
//  Created by Gab on 2024/04/24.
//

import SwiftUI

import Kingfisher

struct ChatGifView: View {
    
    @State private var viewState: Bool = false
    var chatModel: MessageChatListModel
    
    var offset: CGFloat
    
    var index: Int
    
    @State private var pointY: CGFloat = .zero
    
    var body: some View {
        VStack {
            if viewState {
                ZStack {
                    KFAnimatedImage(URL(string: chatModel.msgEtc.gifModel.gifUrl))
                        .configure { imageView in
                            imageView.framePreloadCount = 1
                        }
                }
                .frame(width: 150, height: 150)
                .cornerRadius(8)
            } else {
                ZStack {
                    KFImage(URL(string: chatModel.msgEtc.gifModel.gifUrl))
                }
                .frame(width: 150, height: 150)
                .cornerRadius(8)
            }
        }
        .background {
            GeometryReader { geomtryProxy in
                Color.clear
                    .onAppear {
                        pointY = geomtryProxy.frame(in: .named("ChatScrollView")).maxY
                        viewState = abs(offset) < pointY
                    }
            }
        }
        .onChange(of: offset) { newValue in
            viewState = abs(newValue) < pointY
        }
        .onChange(of: viewState) { newValue in
            print("index : \(index) state \(newValue)")
        }
    }
}

//#Preview {
//    ChatGifView()
//}
