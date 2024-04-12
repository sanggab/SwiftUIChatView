//
//  ChatView.swift
//  SwiftUIChatView
//
//  Created by Gab on 2024/04/12.
//

import SwiftUI

public struct ChatView: View {
    public var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 16, content: {
                    ForEach(1...20, id: \.self) { count in
                        Rectangle()
                            .fill(.mint)
                            .frame(height: 100)
                            .overlay {
                                Text("\(count)")
                            }
                    }
                })
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.orange)
        }
    }
}

#Preview {
    ChatView()
}
