//
//  Int.swift
//  SwiftUIChatView
//
//  Created by Gab on 2024/04/18.
//

import UIKit

public extension Int {
    
    func makeLocaleTimeEn() -> String {
        let timeInterval = TimeInterval(self)
        let timeDate = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a hh:mm"
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.timeZone = .current
        
        return dateFormatter.string(from: timeDate)
    }
    
    func makeLocaleDate(isLTR: Bool = true) -> String {
        
        let timeInterval = TimeInterval(self)
        
        let timeDate = Date(timeIntervalSince1970: timeInterval)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = .current
        dateFormatter.timeZone = .current
        
        if !isLTR {
            dateFormatter.locale = Locale(identifier: "en")
        }
        
        return dateFormatter.string(from: timeDate)
    }
}
