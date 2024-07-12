//
//  ChatView.swift
//  SwiftUIChatView
//
//  Created by Gab on 2024/04/12.
//


import SwiftUI

import SwiftUIIntrospect

// tag 1.3

public struct ChatView: View {
    @State private var blankHeight: CGFloat = 0
    
    @State private var visibleIndex: [Int] = []
    
    @State private var scrollSize: CGSize = .zero
    
    @State private var keyobardState: Bool = false
    
    @State private var mainScrollView: UIScrollView?
    
    @State private var chatList: [Int] = [1710311216, 1710311322, 1710311342, 1710311348, 1710311364, 1710311370, 1710311374, 1710311376, 1710311386, 1710311400, 1710311422, 1710311423, Int(Date().timeIntervalSince1970)]
    
    
    @State private var chatList2: [MessageChatListModel] = MessageChatListModel.makeList()
    
    @State private var offset: CGFloat = .zero
    
    public var body: some View {
        ScrollViewReader { scrollProxy in
            VStack(spacing: 0) {
                Rectangle()
                    .fill(.pink)
                    .frame(height: blankHeight)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                     
                        ForEach(Array(chatList2.enumerated()), id: \.element) { index, model in
                            if model.msgType == .gif {
                                
                                ChatGifView(chatModel: model,
                                            offset: offset,
                                            index: index)
                                
                            } else {
                                Rectangle()
                                    .fill(.mint)
                                    .overlay {
                                        Text("\(index)")
                                    }
                                    .frame(height: 100)
                            }
                        }
                        
                       
                    }
                    .background {
                        GeometryReader { proxy in
                            let frame = proxy.frame(in: .named("ChatScrollView"))
                            
                            Color.clear
                                .preference(key: ChatScrollOffsetKey.self, value: frame.origin.y)
                                .preference(key: ChatListHeightKey.self, value: frame.height)
                        }
                    }
                    .rotationEffect(.degrees(180))
                }
                .coordinateSpace(name: "ChatScrollView")
                .background(.gray)
                .introspect(.scrollView, on: .iOS(.v15, .v16, .v17)) { introScrollView in
                    mainScrollView = introScrollView
                }
                .onPreferenceChange(ChatScrollOffsetKey.self) { scrollOffset in
                    offset = scrollOffset
//                    print("offset -> \(offset)")
                }
                .onPreferenceChange(ChatListHeightKey.self) { height in
                    print("ChatListHeightKey -> \(height)")
                }
                .getKeyboardOutput { output, state in
                    keyboardAction(output, state)
                }
            }
            .background(.clear)
            .rotationEffect(.degrees(180))
        }
    }
    
    private func keyboardAction(_ output: NotificationCenter.Publisher.Output, _ state: KeyBoardState) {
        state == .show ? keyboardShowAction(output) : keyboardHideAction(output)
    }
    
    private func keyboardShowAction(_ output: NotificationCenter.Publisher.Output) {
        print("keyboardShowAction")
        if let userInfo = output.userInfo {
            if let size = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            }
        }
    }
    
    private func keyboardHideAction(_ output: NotificationCenter.Publisher.Output) {
        print("keyboardHideAction")
        withAnimation(.keyboardAnimation(from: output)) {
//            blankHeight = 0
        }
    }
}

#Preview {
    ChatView()
}
