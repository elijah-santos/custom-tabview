//
//  ArrayCustomTabContent.swift
//  CustomTabView
//
//  Created by Elijah Santos on 8/28/25.
//

import Foundation

@MainActor
internal struct ArrayCustomTabContent<Value: Hashable>: CustomTabContent {
    typealias ContentArray = [any CustomTabContent<Value>]
    
    private var content: ContentArray
    
    init(array: ContentArray) {
        self.content = array
    }
    
    var body: some CustomTabContent<Value> {
        ParameterizedNeverCustomTabContent<Value>
            .fatalError("ArrayCustomTabContent does not have a body")
    }
    
    var _tabs: [_CustomTabViewItem<Value>] {
        return content.flatMap { $0._tabs }
    }
}
