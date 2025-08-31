//
//  CustomTabViewConfiguration.swift
//  CustomTabView
//
//  Created by Elijah Santos on 8/28/25.
//

import Foundation
import SwiftUI

/// The configuration passed to a `CustomTabViewStyle` with info about what tabs and groups are present, as well as the content.
@MainActor
public struct CustomTabViewConfiguration {
    /// The label attached to a `CustomTab` or a `CustomTabSection`.
    ///
    /// This can be used as a view in its own right, or you can use the ``title`` and ``image`` properties for greater control.
    public struct TabLabel: View {
        init<T>(tag: _CustomTabViewItem<T>._Tag) {
            self.title = tag.label
            self.image = switch tag.image {
            case .custom(let name):
                Image(name)
            case .system(let name):
                Image(systemName: name)
            case nil:
                nil
            }
        }
        public let title: String
        public let image: Image?
        
        public var body: some View {
            Label {
                Text(title)
            } icon: {
                image
            }
        }
    }
    
    /// The erased content of a `CustomTab`.
    public struct TabContentView: View {
        let actualView: AnyView
        
        public var body: some View {
            actualView
        }
    }
    
    /// An item in a `CustomTabView` (either a tab or a section).
    public enum Item: Identifiable {
        /// A tab in the `CustomTabView`.
        public struct Tab: Identifiable {
            init(id: AnyHashable, label: TabLabel, content: TabContentView, selected: Bool, selectFunction: @escaping () -> Void) {
                self.id = id
                self.label = label
                self.content = content
                self.selected = selected
                self.selectFunction = selectFunction
            }
            
            /// A stable identifier of the tab.
            public let id: AnyHashable
            /// The label assigned to the tab.
            public var label: TabLabel
            /// The content of the tab.
            public var content: TabContentView
            /// Whether the tab is selected.
            ///
            /// Call ``select()`` to select the tab.
            public let selected: Bool
            
            private let selectFunction: () -> Void
            
            /// Selects the tab.
            ///
            /// - Note: This does not immediately change the value of the ``selected`` property of this or any other tab.
            public func select() {
                selectFunction()
            }
        }
        
        /// A section containing more tabs and/or more sections.
        public struct Section: Identifiable {
            init(id: AnyHashable, label: TabLabel? = nil, items: [Item]) {
                self.id = id
                self.label = label
                self.items = items
            }
            
            /// A stable identifier for the section.
            public let id: AnyHashable
            /// The label for the section, if provided.
            public var label: TabLabel?
            /// The items the section contains, be they tabs or sections.
            ///
            /// Compare to ``tabs``.
            public var items: [Item]
            /// A flat list of the tabs in the section, flattening nested sections.
            ///
            /// Note that this property breaks the hierarchical structure of nested sections, which does lose information. This does
            /// mimic the behavior of `SwiftUI.TabView` which does not respect nested sections.
            ///
            /// Compare to ``items``.
            public var tabs: [Tab] {
                items.flatMap {
                    switch $0 {
                    case .tab(let tab):
                        [tab]
                    case .section(let section):
                        section.tabs
                    }
                }
            }
        }
        
        /// A tab.
        case tab(Tab)
        
        /// A section containing more tabs.
        case section(Section)
        
        /// A stable identifier for the item.
        public var id: some Hashable {
            switch self {
            case .tab(let tab):
                tab.id
            case .section(let section):
                section.id
            }
        }
    }
    
    init(items: [Item]) {
        self.items = items
    }
    
    /// The items at the root level of the ``CustomTabView``.
    public var items: [Item]
    /// The tab that is currently selected.
    ///
    /// This can be `nil` in very few scenarios, mostly if the `CustomTabView` has no tabs, or if a tab has been removed.
    public var selectedTab: Item.Tab? {
        firstSelected(in: self.items)
    }
    
    private func firstSelected(in items: [Item]) -> Item.Tab? {
        for item in items {
            switch item {
            case .tab(let tab):
                if tab.selected {
                    return tab
                }
            case .section(let section):
                if let sel = firstSelected(in: section.items) {
                    return sel
                }
            }
        }
        return nil
    }
}
