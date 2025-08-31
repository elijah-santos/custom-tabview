//
//  Environment+customTabViewStyle.swift
//  CustomTabView
//
//  Created by Elijah Santos on 8/28/25.
//

import Foundation
import SwiftUI

@MainActor
extension EnvironmentValues {
    @MainActor
    private struct CustomTabViewStyleKey: @MainActor SwiftUICore.EnvironmentKey {
        static var defaultValue: any CustomTabViewStyle = .native
    }
    
    
    internal var customTabViewStyle: any CustomTabViewStyle {
        get {
            self[CustomTabViewStyleKey.self]
        }
        set {
            self[CustomTabViewStyleKey.self] = newValue
        }
    }
}
