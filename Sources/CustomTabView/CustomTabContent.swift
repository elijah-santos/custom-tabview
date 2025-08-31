//
//  CustomTabContent.swift
//  CustomTabView
//
//  Created by Elijah Santos on 8/28/25.
//

import Foundation

/// A protocol to which `CustomTab` and `CustomTabSection` conform that is the building block of a `CustomTabView`.
///
/// You can write your own conformances to this protocol with bodies defined in terms of other `CustomTabContent`. The `Value`
/// associated type tracks the selection value attached to the content (used for `CustomTabView`s with a selection binding).
///
/// Analogous to `SwiftUI.TabContent`.
@MainActor
public protocol CustomTabContent<Value> {
    associatedtype Value: Hashable
    associatedtype Body: CustomTabContent<Value>
    
    @CustomTabContentBuilder<Value>
    var body: Body { get }
    
    
    // private API
    // the tab items represented by self
    /// This method is private and should not be implemented or called outside the package.
    @_spi(Hidden)
    var _tabs: [_CustomTabViewItem<Value>] { get }
    
    
}

extension CustomTabContent {
    @_spi(Hidden)
    public var _tabs: [_CustomTabViewItem<Value>] {
        return body._tabs
    }
}
