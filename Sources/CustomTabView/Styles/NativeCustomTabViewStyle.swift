//
//  NativeCustomTabViewStyle.swift
//  CustomTabView
//
//  Created by Elijah Santos on 8/28/25.
//

import Foundation
import SwiftUI

/// A `CustomTabViewStyle` that delegates to `SwiftUI.TabView`.
///
/// You should generally use the `.native` static property rather than directly instantiating this type.
/// When using `.native` style, you can apply `tabViewStyle` as normal to use `SwiftUI.TabViewStyle`.
@MainActor
public struct NativeCustomTabViewStyle: CustomTabViewStyle {
    public init() {}
    
    private struct Content: TabContent {
        let items: [Configuration.Item]
        
        var body: some TabContent<AnyHashable> {
            ForEach(items, id: \.id) { item in
                switch item {
                case .section(let section):
                    if let header = section.label {
                        TabSection {
                            Content(items: section.items)
                        } header: {
                            header
                        }
                    } else {
                        TabSection {
                            Content(items: section.items)
                        }
                    }
                case .tab(let tab):
                    Tab(value: tab.id) {
                        tab.content
                    } label: {
                        tab.label
                    }
                }
            }
        }
    }
    
    private struct HelperView: View {
        @State private var selection: AnyHashable = .init([0])
        let configuration: Configuration
        
        var body: some View {
            TabView(selection: $selection) {
                Content(items: configuration.items)
            }
            .onChange(of: firstSelected(in: configuration.items), initial: true) { _, newValue in
                if let newValue, newValue != selection {
                    self.selection = newValue
                }
            }
            .onChange(of: selection) { _, newValue in
                selectFirst(in: configuration.items, withID: newValue)
            }
        }
    }
    
    
    
    public func makeBody(configuration: Configuration) -> some View {
        HelperView(configuration: configuration)
    }
}

@MainActor
private func firstSelected(in items: [CustomTabViewConfiguration.Item]) -> AnyHashable? {
    for item in items {
        switch item {
        case .tab(let tab):
            if tab.selected {
                return tab.id
            }
        case .section(let section):
            return firstSelected(in: section.items)
        }
    }
    return nil
}

@MainActor
private func selectFirst(in items: [CustomTabViewConfiguration.Item], withID id: AnyHashable) {
    for item in items {
        switch item {
        case .tab(let tab):
            if tab.id == id {
                tab.select()
                return
            }
        case .section(let section):
            selectFirst(in: section.items, withID: id)
        }
    }
    return
}

extension CustomTabViewStyle where Self == NativeCustomTabViewStyle {
    /// A `CustomTabViewStyle` that delegates to `SwiftUI.TabView`.
    ///
    /// When using `.native`, you can apply `tabViewStyle` as normal to use `SwiftUI.TabViewStyle`.
    @MainActor
    public static var native: NativeCustomTabViewStyle {
        return .init()
    }
}
