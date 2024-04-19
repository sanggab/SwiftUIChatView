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
    
    @State private var chatList: [Int] = [1710311216, 1710311322, 1710311342, 1710311348, 1710311364, 1710311370, 1710311374, 1710311376, 1710311386, 1710311400, 1710311422, 1710311423, Int(Date().timeIntervalSince1970)]
    
    public var body: some View {
        ScrollViewReader { scrollProxy in
            VStack(spacing: 0) {
                Rectangle()
                    .fill(.pink)
                    .frame(height: blankHeight)
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 16, content: {
                        
                        ForEach(Array(chatList.reversed().enumerated()), id: \.element) { index, time in
                            Rectangle()
                                .fill(.mint)
                                .frame(height: 100)
//                                .id("Rectangle\(index)")
                                .overlay {
                                    Text("\(index)")
                                }
                                .onAppear {
//                                    print("onAppear count -> \(index)")
                                }
                                .onDisappear {
//                                    print("onDisappear count -> \(index)")
                                }
                                .rotationEffect(.degrees(180))
                                .id("Rectangle\(index)")
                                .onTapGesture {
                                    chatList.append(Int(Date().timeIntervalSince1970) + 100000)
                                }
                            
                            if index == chatList.count - 1 {
                                ChatDateDivisionView(date: time.makeLocaleDate())
                                    .rotationEffect(.degrees(180))
                            } else {
                                let preDate = chatList.reversed()[index + 1]
                                let _ = print("index -> \(index)")
                                let _ = print("time -> \(time)")
                                let _ = print("preDate -> \(preDate)")
//                                let _ = print("date -> \(time.makeLocaleDate())")
                                
                                if preDate.makeLocaleDate() != time.makeLocaleDate() {
                                    ChatDateDivisionView(date: time.makeLocaleDate())
                                        .rotationEffect(.degrees(180))
                                }
                            }
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
                    print("offset -> \(offset)")
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
