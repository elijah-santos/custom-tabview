//
//  View+customTabViewStyle.swift
//  CustomTabView
//
//  Created by Elijah Santos on 8/29/25.
//

import Foundation
import SwiftUI

@MainActor
extension View {
    /// Set the style for all descendant ``CustomTabView``s.
    ///
    /// In order to have ``CustomTabView`` use a system `TabView`, pass in `.native`.
    public func customTabViewStyle<S: CustomTabViewStyle>(_ style: S) -> some View {
        environment(\.customTabViewStyle, style)
    }
}
