//
//  CustomTabContentBuilder.swift
//  CustomTabView
//
//  Created by Elijah Santos on 8/28/25.
//

import Foundation
import SwiftUI

/// The result builder used to create the content of a `CustomTabView`.
///
/// The generic parameter represents the type of the selection passed into `CustomTabView`, or `Never` if no such binding is given.
///
/// Analogous to `SwiftUI.TabContentBuilder`.
@MainActor
@resultBuilder
public enum CustomTabContentBuilder<T: Hashable> {
    public typealias Component = any CustomTabContent<T>
    
    public static func buildBlock(_ components: Component...) -> some CustomTabContent<T> {
//        return ArrayCustomTabContent(array: [])
        return ArrayCustomTabContent(array: components)
    }
    
    public static func buildExpression<Data, ID>(_ expression: ForEach<Data, ID, _CustomTabContentView<T>>) -> some CustomTabContent<T> {
        return ArrayCustomTabContent(array: expression.data.map(expression.content)
            .map { $0.tabContent })
    }
    
    public static func buildExpression<C: CustomTabContent<T>>(_ expression: C) -> some CustomTabContent<T> {
        expression
    }
    
    public static func buildEither(first component: some CustomTabContent<T>) -> some CustomTabContent<T> {
        component
    }
    
    public static func buildEither(second component: some CustomTabContent<T>) -> some CustomTabContent<T> {
        component
    }
    
    public static func buildOptional(_ component: (some CustomTabContent<T>)?) -> some CustomTabContent<T> {
        if let component {
            ArrayCustomTabContent<T>(array: [component])
        } else {
            ArrayCustomTabContent<T>(array: [])
        }
    }
    
    public static func buildLimitedAvailability(_ component: some CustomTabContent<T>) -> some CustomTabContent<T> {
        component
    }
}


// MARK: - Overload error message hints
// these extensions exist to provide more useful errors if using a mismatched `Value`
extension CustomTabContentBuilder where T == Never {
    @available(*, unavailable,
                message: """
                Cannot use CustomTabContent<T> (T != Never) in a CustomTabContentBuilder<Never>; \
                if the surrounding context is a CustomTabView, either remove `value` or provide a \
                selection binding of the correct type.
                """)
    @_disfavoredOverload
    public static func buildExpression<U>(_ expression: some CustomTabContent<U>) -> some CustomTabContent<T> {
        ParameterizedNeverCustomTabContent<T>
            .fatalError("This method should be unavailable")
    }
}

extension CustomTabContentBuilder {
    @available(*, unavailable,
                message: """
                Cannot use CustomTabContent<Never> in a CustomTabView with a \
                selection binding, check generic parameters; if this is a Tab, ensure you \
                provide `value` or remove the selection binding.
                """)
    @_disfavoredOverload
    public static func buildExpression(_ expression: some CustomTabContent<Never>) -> some CustomTabContent<T> {
        ParameterizedNeverCustomTabContent<T>
            .fatalError("This method should be unavailable")
    }
}
