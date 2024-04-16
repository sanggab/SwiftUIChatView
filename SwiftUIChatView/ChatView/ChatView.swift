//
//  ChatView.swift
//  SwiftUIChatView
//
//  Created by Gab on 2024/04/12.
//

import SwiftUI

public struct ChatView: View {
    @State private var blankHeight: CGFloat = 56
    
    @State private var visibleIndex: [Int] = []
    
    @State private var scrollSize: CGSize = .zero
    
    @State private var keyobardState: Bool = false
    
    public var body: some View {
        ScrollViewReader { scrollProxy in
            VStack(spacing: 0, content: {
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
                                .background {
                                    GeometryReader { geometry in
                                        Color.clear
                                            .onChange(of: geometry.frame(in: .named("ChatScrollView"))) { frame in
                                                
                                                print("count \(count) -> \(frame.midY)")
                                                if frame.midY <= scrollSize.height - blankHeight {
                                                    visibleIndex.removeAll(where: { $0 == count })
                                                    visibleIndex.append(count)
                                                } else{
                                                    visibleIndex.removeAll(where: { $0 == count })
                                                }
                                                visibleIndex.sort()
                                                print("visibleIndex -> \(visibleIndex)")
                                            }
                                    }
                                }
    //                            .frame(width: UIScreen.main.bounds.width, height: 100)
                        }
                    })
                    .id(UUID())
                }
                .coordinateSpace(name: "ChatScrollView")
                .background {
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                print("Scroll Area size")
    //                            print("size -> \(geometry.frame(in: .global))")
                                scrollSize = geometry.size
                            }
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { output in
                    print("keyboardWillShowNotification")
                    if let userInfo = output.userInfo {
                        if let size = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                            guard let lastCount = visibleIndex.last else {
                                return
                            }
                            
                            keyobardState = true
                            
                            print("lastCount -> \(lastCount)")
                            withAnimation(.keyboardAnimation(from: output)) {
                                blankHeight = size.height + 56 - 34
                            }
                            
                            scrollProxy.scrollTo("Rectangle\(lastCount)", anchor: .top)
                        }
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { output in
                    print("keyboardWillHideNotification")
                    guard let lastCount = visibleIndex.last else {
                        return
                    }
                    
                    print("lastCount -> \(lastCount)")
                    
                    withAnimation(.keyboardAnimation(from: output)) {
                        blankHeight = 56
                        scrollProxy.scrollTo("Rectangle\(lastCount)", anchor: .bottom)
                    }
                    
                    keyobardState = false
                }
                
                Rectangle()
                    .fill(.mint)
                    .frame(height: blankHeight)
            })
        }
        .ignoresSafeArea(.keyboard, edges: .all)
    }
}

#Preview {
    ChatView()
}
