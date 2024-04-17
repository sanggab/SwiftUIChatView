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
    
    public var body: some View {
        ScrollViewReader { scrollProxy in
            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 16, content: {
                        ForEach(1...20, id: \.self) { count in
                            Rectangle()
                                .fill(.mint)
                                .frame(height: 100)
                                .id("Rectangle\(count)")
                                .overlay {
                                    Text("\(count)")
                                }
                        }
                    })
                    .id(UUID())
                    .background {
                        GeometryReader { proxy in
                            let frame = proxy.frame(in: .named("ChatScrollView"))
                            
                            Color.clear
                                .preference(key: ChatScrollOffsetKey.self, value: frame.origin.y)
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
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { output in
                    print("keyboardWillShowNotification")
                    if let userInfo = output.userInfo {
                        if let size = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                            print("mainScrollView contentOffset -> \(mainScrollView?.contentOffset)")
                            
                            guard let scrollView = mainScrollView else {
                                return
                            }
                            
                            let newOffset: CGPoint = CGPoint(x: scrollView.contentOffset.x, y: (scrollView.contentOffset.y + size.height - 34))
                            print("newOffset -> \(newOffset)")
                            
                            mainScrollView?.setContentOffset(newOffset, animated: false)
                            
                            print("mainScrollView contentOffset -> \(mainScrollView?.contentOffset)")
                        }
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { output in
                    print("keyboardWillHideNotification")
                    guard let scrollView = mainScrollView else {
                        return
                    }
                    
                    if let userInfo = output.userInfo {
                        if let size = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                            print("mainScrollView contentOffset -> \(mainScrollView?.contentOffset)")
                            
                            guard let scrollView = mainScrollView else {
                                return
                            }
                            
                            let offsetY = max(0, scrollView.contentOffset.y - size.height + 34)
                            
                            let newOffset: CGPoint = CGPoint(x: scrollView.contentOffset.x, y: offsetY)
                            print("newOffset -> \(newOffset)")
                            
                            mainScrollView?.setContentOffset(newOffset, animated: false)
                            
                            print("mainScrollView contentOffset -> \(mainScrollView?.contentOffset)")
                        }
                    }
                }
                
                Rectangle()
                    .fill(.pink)
                    .frame(height: blankHeight)
                    
            }
        }
    }
}

#Preview {
    ChatView()
}
