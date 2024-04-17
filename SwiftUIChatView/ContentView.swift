//
//  ContentView.swift
//  SwiftUIChatView
//
//  Created by Gab on 2024/04/08.
//

import SwiftUI
import SwiftUITextView

public struct ContentView: View {
    @State private var text: String = ""
    
    @State private var selection: Int = 0
    
    @State private var keyboardHeight: CGFloat = .zero
    
    @State private var safeAreaInsets: EdgeInsets = .init()
    
    @FocusState private var keyboardState
    
    public var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selection) {
                
                ChatView()
                    .tag(0)
                
                ProfileView()
                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.bottom, 56)
            .overlay(alignment: .bottom) {
                TextView(text: $text, style: .placeHolder)
                    .setInputModel(TextViewInputModel(placeholderText: "Enter message",
                                                      placeholderColor: .gray,
                                                      placeholderFont: .boldSystemFont(ofSize: 15),
                                                      focusColor: .black,
                                                      focusFont: .boldSystemFont(ofSize: 15)))
                    .focused($keyboardState)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(.blue)
                    .padding(.bottom, keyboardHeight > 0 ? keyboardHeight - safeAreaInsets.bottom : keyboardHeight)
                    .getKeyboardHeight($keyboardHeight)
                    .getKeyboardOutput { output, state in
                        print("state -> \(state)")
                        print("output -> \(output)")
                    }
            }
            .onTapGesture {
                keyboardState = false
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        safeAreaInsets = geometry.safeAreaInsets
                    }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .all)
    }
}

#Preview {
    ContentView()
}
