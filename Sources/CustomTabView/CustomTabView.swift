//
//  CustomTabView.swift
//  CustomTabView
//
//  Created by Elijah Santos on 8/28/25.
//

import Foundation
import SwiftUI

/// A view whose content varies based on which one of multiple options are selected.
///
/// If you don't care about which tab is selected, use `init(content:)`:
/// ```swift
/// CustomTabView {
///     CustomTab("Option 1") { ... }
///     CustomTab("Option 2") { ... }
///     CustomTabSection("Section") {
///         CustomTab("Option 3") { ... }
///         CustomTab("Option 4") { ... }
///     }
/// }
/// ```
///
/// If you want to programmatically select the tab or react to the user's selection, use `init(selection:content:)` and
/// `CustomTab` initializers that take a value:
/// ```swift
/// CustomTabView(selection: $number) {
///     CustomTab("Option 1", value: 1) { ... }
///     CustomTab("Option 2", value: 2) { ... }
///     CustomTabSection("Section") {
///         CustomTab("Option 3", value: 3) { ... }
///         CustomTab("Option 4", value: 4) { ... }
///     }
/// }
/// ```
///
/// Analogous to `SwiftUI.TabView`, but allows for user-defined styles (see: ``CustomTabViewStyle``).
@MainActor
public struct CustomTabView<Value: Hashable, Content: CustomTabContent<Value>>: View {
    private struct FallbackSelectionType: Hashable {
        var path: [Int]
        
        static var empty: FallbackSelectionType { .init(path: []) }
    }
    
    @State private var fallbackSelection: FallbackSelectionType = .empty
    // TODO: handle the case where the selected value's tab is removed; set selection to sth else
    // selection is only nil if Value is Never
    @Binding private var selection: Value?
    @Environment(\.customTabViewStyle) private var style: any CustomTabViewStyle
    
    private let content: Content
    
    /// Creates a `CustomTabView` that manages its own selection value.
    ///
    /// See the documentation on the type for more info.
    public init(
        @CustomTabContentBuilder<Value> content: () -> Content
    ) where Value == Never {
        self._selection = .constant(nil)
        self.content = content()
    }
    
    /// Creates a `CustomTabView` whose selection is linked to the value of the passed-in binding.
    ///
    /// See the documentation on the type for more info.
    public init(
        selection: Binding<Value>,
        @CustomTabContentBuilder<Value> content: () -> Content
    ) {
        self._selection = .init(
            get: { selection.wrappedValue },
            set: {
                if let newValue = $0 {
                    selection.wrappedValue = newValue
                }
            })
        self.content = content()
    }
    
    public var body: some View {
        style.makeErasedBody(configuration: configuration)
    }
    
    private var configuration: CustomTabViewConfiguration {
        // true if there is currently no selection
        var needsToSelectATab = selection == nil && fallbackSelection == .empty
        
        let tabs = content._tabs
        
        var result: [CustomTabViewConfiguration.Item] = []
        
        result = processTabItems(tabs, needsToSelectATab: &needsToSelectATab, path: [])
        
        return .init(items: result)
    }
    
    private func processTabItems(
        _ items: [_CustomTabViewItem<Value>],
        needsToSelectATab: inout Bool,
        path: [Int]
    ) -> [CustomTabViewConfiguration.Item] {
        var result: [CustomTabViewConfiguration.Item] = []
        
        for (offset, tab) in items.enumerated() {
            let newPath = path + CollectionOfOne(offset)
            
            switch tab {
            case .section(let sectionHeader, let contents):
                // TODO: better, more persistent ID for sections; maybe change the result builder?
                // currently using the first identified tab as an ID (better than just the path)
                // using the first identified tab as an ID means that, if Value is not Never,
                // the section has an ID that is not defined by its position, and is more likely
                // to be persistent across view updates
                let id = contents.first(where: {
                    if case .tab(_, let tag) = $0, tag.value != nil {
                        true
                    } else {
                        false
                    }
                }).map {
                    guard case .tab(_, let tag) = $0, let value = tag.value else {
                        fatalError("something went wrong in the first(where:)")
                    }
                    return AnyHashable(value)
                } ?? AnyHashable(newPath)
                
                result.append(.section(.init(
                    id: id,
                    label: sectionHeader.map(CustomTabViewConfiguration.TabLabel.init(tag:)),
                    items: processTabItems(
                        contents,
                        needsToSelectATab: &needsToSelectATab,
                        path: newPath))))
            case .tab(let view, let tag):
                let id = tag.value.map { AnyHashable($0) } ?? AnyHashable(newPath)
                
                var selected = tabMatchesSelection(id: id, path: newPath)
                if needsToSelectATab {
                    // force fallback selection to match this tab -- selects the first tab found
                    selected = true
                    DispatchQueue.main.async {
                        fallbackSelection = .init(path: newPath)
                    }
                    needsToSelectATab = false
                }
                
                result.append(.tab(.init(
                    id: id,
                    label: .init(tag: tag),
                    content: .init(actualView: view),
                    selected: selected,
                    selectFunction: {
                        if let value = tag.value {
                            // set normal selection -- Value is not Never
                            self.selection = value
                        }
                        self.fallbackSelection = .init(path: newPath)
                    })))
            }
        }
        
        return result
    }
    
    private func tabMatchesSelection(id: AnyHashable, path: [Int]) -> Bool {
        selection.map { AnyHashable($0) == id } ?? (fallbackSelection.path == path)
    }
}
