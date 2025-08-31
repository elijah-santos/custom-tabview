//
//  SwiftUIView.swift
//  CustomTabView
//
//  Created by Elijah Santos on 8/28/25.
//

import SwiftUI

@MainActor
extension ForEach {
    /// Iterates over a `RandomAccessCollection` of `Value` using their unique IDs to produce `CustomTabContent`.
    ///
    /// - Warning: While the result of this initializer is a valid `View`, do not use it outside of `CustomTabContentBuilder`.
    /// Doing so will call `fatalError`.
    public init<Value: Hashable, TabContent: CustomTabContent<Value>>(
        _ data: Self.Data,
        @CustomTabContentBuilder<Value> content: @escaping (Data.Element) -> TabContent
    ) where Content == _CustomTabContentView<Value>, Data.Element: Identifiable, ID == Data.Element.ID {
        self.init(data) { element in
            _CustomTabContentView(tabContent: content(element))
        }
    }
    
    /// Iterates over a `RandomAccessCollection` of `Value` using `id`-based IDs to produce `CustomTabContent`.
    ///
    /// - Warning: While the result of this initializer is a valid `View`, do not use it outside of `CustomTabContentBuilder`.
    /// Doing so will call `fatalError`.
    public init<Value: Hashable, TabContent: CustomTabContent<Value>>(
        _ data: Self.Data,
        id keyPath: KeyPath<Data.Element, ID>,
        @CustomTabContentBuilder<Value> content: @escaping (Data.Element) -> TabContent
    ) where Content == _CustomTabContentView<Value> {
        self.init(data, id: keyPath) { element in
            _CustomTabContentView(tabContent: content(element))
        }
    }
    
    // Never overloads
    /// Iterates over a `RandomAccessCollection` of `Value` using their unique IDs to produce `CustomTabContent`.
    ///
    /// - Warning: While the result of this initializer is a valid `View`, do not use it outside of `CustomTabContentBuilder`.
    /// Doing so will call `fatalError`.
    public init<TabContent: CustomTabContent<Never>>(
        _ data: Self.Data,
        @CustomTabContentBuilder<Never> content: @escaping (Data.Element) -> TabContent
    ) where Content == _CustomTabContentView<Never>, Data.Element: Identifiable, ID == Data.Element.ID {
        self.init(data) { element in
            _CustomTabContentView(tabContent: content(element))
        }
    }
    
    /// Iterates over a `RandomAccessCollection` of `Value` using `id`-based IDs to produce `CustomTabContent`.
    ///
    /// - Warning: While the result of this initializer is a valid `View`, do not use it outside of `CustomTabContentBuilder`.
    /// Doing so will call `fatalError`.
    public init<TabContent: CustomTabContent<Never>>(
        _ data: Self.Data,
        id keyPath: KeyPath<Data.Element, ID>,
        @CustomTabContentBuilder<Never> content: @escaping (Data.Element) -> TabContent
    ) where Content == _CustomTabContentView<Never> {
        self.init(data, id: keyPath) { element in
            _CustomTabContentView(tabContent: content(element))
        }
    }
}
