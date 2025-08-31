//
//  CustomTabViewStyle.swift
//  CustomTabView
//
//  Created by Elijah Santos on 8/28/25.
//

import Foundation
import SwiftUI

/// A style that determines how to draw a ``CustomTabView``.
///
/// Pass an instance of a struct that conforms to this protocol to `View.customTabViewStyle(_:)` to style the
/// `CustomTabView`s in descendant views.
///
/// For an example implementation, see the documentation for ``makeBody(configuration:)``.
@MainActor
public protocol CustomTabViewStyle {
    associatedtype Body: View
    typealias Configuration = CustomTabViewConfiguration
    
    /// Using  `configuration`, create a view showing both the tabs and the currently selected tab's body.
    ///
    /// The following is a very basic example implementation of the body of this method:
    /// ```swift
    /// HStack {
    ///     VStack {
    ///         ForEach(configuration.items) { item in
    ///             switch item {
    ///             case .section(let section):
    ///                 GroupBox {
    ///                     ForEach(section.tabs) { tab in
    ///                         tab.label
    ///                             .foregroundStyle(tab.selected ? .blue : .primary)
    ///                             .onTapGesture {
    ///                                 tab.select()
    ///                             }
    ///                     }
    ///                 } label: {
    ///                     section.label
    ///                 }
    ///             case .tab(let tab):
    ///                 tab.label
    ///                     .foregroundStyle(tab.selected ? .blue : .primary)
    ///                     .onTapGesture {
    ///                         tab.select()
    ///                     }
    ///             }
    ///         }
    ///     }
    ///     Divider()
    ///     configuration.selectedTab?.content
    ///         .frame(maxWidth: .infinity, maxHeight: .infinity)
    /// }
    /// ```
    @ViewBuilder
    func makeBody(configuration: Configuration) -> Body
}

internal extension CustomTabViewStyle {
    func makeErasedBody(configuration: Configuration) -> AnyView {
        AnyView(makeBody(configuration: configuration))
    }
}
