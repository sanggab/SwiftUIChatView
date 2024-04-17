//
//  View.swift
//  SwiftUIChatView
//
//  Created by Gab on 2024/04/17.
//

import SwiftUI

@frozen
public enum KeyBoardState: Equatable {
    case show
    case hide
}


public struct KeyBoardModifier: ViewModifier {
    
    @Binding public var height: CGFloat
    public var outputClosure: ((NotificationCenter.Publisher.Output, KeyBoardState) -> Void)?
    
    public init(height: Binding<CGFloat> = .constant(.zero),
                outputClosure: ((NotificationCenter.Publisher.Output, KeyBoardState) -> Void)? = nil) {
        self._height = height
        self.outputClosure = outputClosure
    }
    
    public func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { output in
                if let outputClosure {
                    outputClosure(output, .show)
                } else {
                    if let userInfo = output.userInfo {
                        if let size = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                            withAnimation(.keyboardAnimation(from: output)) {
                                height = size.height
                            }
                        }
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { output in
                if let outputClosure {
                    outputClosure(output, .hide)
                } else {
                    withAnimation(.keyboardAnimation(from: output)) {
                        height = .zero
                    }
                }
            }
    }
}

public extension View {
    
    @inlinable func getKeyboardHeight(_ height: Binding<CGFloat>) -> some View {
        modifier(KeyBoardModifier(height: height))
    }
    
    @inlinable func getKeyboardOutput(_ output: @escaping ((NotificationCenter.Publisher.Output, KeyBoardState) -> Void)) -> some View {
        modifier(KeyBoardModifier(outputClosure: output))
    }
}
