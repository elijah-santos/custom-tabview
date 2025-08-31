//
//  CustomTabSection.swift
//  CustomTabView
//
//  Created by Elijah Santos on 8/28/25.
//

import Foundation

/// A section of tabs in a `CustomTabView`.
///
/// Pass in (optionally) a title and an image to use for the section header, as well as a closure to produce the contained tabs.
///
/// Analogous to `SwiftUI.TabSection`.
@MainActor
public struct CustomTabSection<Value: Hashable, Content: CustomTabContent<Value>>: CustomTabContent {
    private let content: Content
    private let tag: _CustomTabViewItem<Value>._Tag?
    
    public init(
        @CustomTabContentBuilder<Value> content: () -> Content
    ) {
        self.content = content()
        self.tag = nil
    }
    
    public init(
        _ title: String,
        systemImage: String,
        @CustomTabContentBuilder<Value> content: () -> Content
    ) {
        self.content = content()
        self.tag = .init(label: title, image: .system(systemImage), value: nil)
    }
    
    public init(
        _ title: String,
        image: String,
        @CustomTabContentBuilder<Value> content: () -> Content
    ) {
        self.content = content()
        self.tag = .init(label: title, image: .custom(image), value: nil)
    }
    
    public init(
        _ title: String,
        @CustomTabContentBuilder<Value> content: () -> Content
    ) {
        self.content = content()
        self.tag = .init(label: title, image: nil, value: nil)
    }
    
    /// This property is private. Do not call it, as it will call `fatalError`.
    @_spi(Hidden)
    public var body: some CustomTabContent<Value> {
        ParameterizedNeverCustomTabContent<Value>
            .fatalError("CustomTabSection does not have a body as it is a primitive")
    }
    
    @_spi(Hidden)
    public var _tabs: [_CustomTabViewItem<Value>] {
        [.section(sectionHeader: tag, contents: content._tabs)]
    }
}
