//
//  ChatDateDivisionView.swift
//  SwiftUIChatView
//
//  Created by Gab on 2024/04/18.
//

import SwiftUI

public struct ChatDateDivisionView: View {
    public let date: String
    
    public init(date: String) {
        self.date = date
    }
    
    public var body: some View {
        ZStack {
            HStack(spacing: 20) {
                Rectangle()
                    .fill(.gray)
                    .frame(height: 1)
                
                Text(date)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 14)
                    .background(.orange)
                    .cornerRadius(12)
                
                Rectangle()
                    .fill(.gray)
                    .frame(height: 1)
            }
            .padding(.horizontal, 12)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ChatDateDivisionView(date: 1710311216.makeLocaleDate())
}
