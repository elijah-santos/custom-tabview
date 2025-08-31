//
//  _CustomTabViewItem.swift
//  CustomTabView
//
//  Created by Elijah Santos on 8/28/25.
//

import Foundation
import SwiftUI

@MainActor
@_spi(Hidden)
public enum _CustomTabViewItem<Value: Hashable> {
    @_spi(Hidden)
    public struct _Tag: Hashable {
        internal enum Image: Hashable {
            case system(String)
            case custom(String)
        }
        let label: String
        let image: Image?
        let value: Value?
    }
    
    case tab(AnyView, _Tag)
    indirect case section(
        sectionHeader: _Tag?,
        contents: [_CustomTabViewItem<Value>])
}
