//
//  Animation.swift
//  SwiftUIChatView
//
//  Created by Gab on 2024/04/16.
//

import SwiftUI

private extension UISpringTimingParameters {
    var mass: Double? {
        value(forKey: "mass") as? Double
    }
    var stiffness: Double? {
        value(forKey: "stiffness") as? Double
    }
    var damping: Double? {
        value(forKey: "damping") as? Double
    }
}

public extension Animation {
    
    static func keyboardAnimation(from notification: Notification) -> Animation? {
        guard
            let info = notification.userInfo,
            let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curveValue = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
            let uiKitCurve = UIView.AnimationCurve(rawValue: curveValue)
        else {
            return nil
        }
        
        let timing = UICubicTimingParameters(animationCurve: uiKitCurve)
        if let springParams = timing.springTimingParameters,
           let mass = springParams.mass, let stiffness = springParams.stiffness, let damping = springParams.damping {
            return Animation.interpolatingSpring(mass: mass, stiffness: stiffness, damping: damping)
        } else {
            return Animation.easeOut(duration: duration) // this is the closest fallback
        }
    }
}
