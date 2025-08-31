//
//  ParameterizedNeverCustomTabContent.swift
//  CustomTabView
//
//  Created by Elijah Santos on 8/28/25.
//

import Foundation

/// Helper for `Never`-returning `CustomTabContent`.
@MainActor
internal enum ParameterizedNeverCustomTabContent<Value: Hashable>: CustomTabContent {
    typealias Body = Self
    
    public var body: Self {
        return Self.fatalError("ParameterizedNeverCustomTabContent has no body")
    }
    
    internal static func fatalError(_ message: @autoclosure () -> String) -> Self {
        Swift.fatalError(message())
    }
}
