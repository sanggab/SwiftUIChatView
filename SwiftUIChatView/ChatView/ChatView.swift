//
//  ChatView.swift
//  SwiftUIChatView
//
//  Created by Gab on 2024/04/12.
//

import SwiftUI

import SwiftUIIntrospect

public struct ChatView: View {
    @State private var blankHeight: CGFloat = 0
    
    @State private var visibleIndex: [Int] = []
    
    @State private var scrollSize: CGSize = .zero
    
    @State private var keyobardState: Bool = false
    
    @State private var mainScrollView: UIScrollView?
    
    @State private var chatList: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    
    public var body: some View {
        ScrollViewReader { scrollProxy in
            VStack(spacing: 0) {
                Rectangle()
                    .fill(.pink)
                    .frame(height: blankHeight)
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 16, content: {
                        
                        ForEach(Array(chatList.reversed()), id: \.self) { count in
                            Rectangle()
                                .fill(.mint)
                                .frame(height: 100)
                                .id("Rectangle\(count)")
                                .overlay {
                                    Text("\(count)")
                                }
                                .onAppear {
                                    print("onAppear count -> \(count)")
                                }
                                .onDisappear {
                                    print("onDisappear count -> \(count)")
                                }
                                .rotationEffect(.degrees(180))
                        }
                    })
                    .id(UUID())
                    .background {
                        GeometryReader { proxy in
                            let frame = proxy.frame(in: .named("ChatScrollView"))
                            
                            Color.clear
                                .preference(key: ChatScrollOffsetKey.self, value: frame.origin.y)
                                .preference(key: ChatListHeightKey.self, value: frame.height)
                        }
                    }
                }
                .coordinateSpace(name: "ChatScrollView")
                .background(.gray)
                .introspect(.scrollView, on: .iOS(.v15, .v16, .v17)) { introScrollView in
                    mainScrollView = introScrollView
                }
                .onPreferenceChange(ChatScrollOffsetKey.self) { offset in
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
