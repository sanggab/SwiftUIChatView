//
//  PreferenceKey.swift
//  SwiftUIChatView
//
//  Created by Gab on 2024/04/16.
//

import SwiftUI

public struct ChatScrollOffsetKey: PreferenceKey {
    public static var defaultValue: CGFloat = .zero
    
    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

public struct ChatListHeightKey: PreferenceKey {
    public static var defaultValue: CGFloat = .zero
    
    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

