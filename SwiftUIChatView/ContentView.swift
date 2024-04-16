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
    
    @FocusState private var keyboardState
    
    public var body: some View {
        TabView(selection: $selection) {
            
            ChatView()
                .tag(0)
            
            ProfileView()
                .tag(1)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
//        .padding(.bottom, 56)
        .ignoresSafeArea(.keyboard, edges: .all)
        .overlay(alignment: .bottom) {
            TextView(text: $text, style: .placeHolder)
                .setInputModel(TextViewInputModel(placeholderText: "Enter message",
                                                  placeholderColor: .gray,
                                                  placeholderFont: .boldSystemFont(ofSize: 15),
                                                  focusColor: .black,
                                                  focusFont: .boldSystemFont(ofSize: 15)))
                .frame(width: UIScreen.main.bounds.width, height: 56)
                .background(.white)
                .focused($keyboardState)
        }
        .onTapGesture {
            keyboardState = false
        }
    }
}

#Preview {
    ContentView()
}
