//
//  CustomTab.swift
//  CustomTabView
//
//  Created by Elijah Santos on 8/28/25.
//

import Foundation
import SwiftUI

/// A tab to be used in a `CustomTabView`.
///
/// Provide a title and (optionally) an image to use as a label. In `CustomTabView`s with a selection binding, pass in a correctly-typed
/// value to track its selection.
///
/// Analogous to `SwiftUI.Tab`.
@MainActor
public struct CustomTab<Value: Hashable, Content: View>: CustomTabContent {
    private let tag: _CustomTabViewItem<Value>._Tag
    private let content: Content
    
    public init(
        _ title: String,
        systemImage: String,
        @ViewBuilder content: () -> Content
    ) where Value == Never {
        self.tag = .init(label: title, image: .system(systemImage), value: nil)
        self.content = content()
    }
    
    public init(
        _ title: String,
        image: String,
        @ViewBuilder content: () -> Content
    ) where Value == Never {
        self.tag = .init(label: title, image: .custom(image), value: nil)
        self.content = content()
    }
    
    public init(
        _ title: String,
        systemImage: String,
        value: Value,
        @ViewBuilder content: () -> Content
    ) {
        self.tag = .init(label: title, image: .system(systemImage), value: value)
        self.content = content()
    }
    
    public init(
        _ title: String,
        image: String,
        value: Value,
        @ViewBuilder content: () -> Content
    ) {
        self.tag = .init(label: title, image: .custom(image), value: value)
        self.content = content()
    }
    
    public init(
        _ title: String,
        @ViewBuilder content: () -> Content
    ) where Value == Never {
        self.tag = .init(label: title, image: nil, value: nil)
        self.content = content()
    }
    
    public init(
        _ title: String,
        value: Value,
        @ViewBuilder content: () -> Content
    ) {
        self.tag = .init(label: title, image: nil, value: value)
        self.content = content()
    }
    
    /// This property is private. Do not call it, as it will call `fatalError`.
    @_spi(Hidden)
    public var body: some CustomTabContent<Value> {
        ParameterizedNeverCustomTabContent<Value>
            .fatalError("CustomTab does not have a body as it is a primitive.")
    }
    
    @_spi(Hidden)
    public var _tabs: [_CustomTabViewItem<Value>] {
        [.tab(AnyView(content), self.tag)]
    }
}
