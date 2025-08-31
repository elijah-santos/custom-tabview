//
//  _CustomTabContentView.swift
//  CustomTabView
//
//  Created by Elijah Santos on 8/28/25.
//

import Foundation
import SwiftUI

/// This type is private. Do not use it outside of the package, as its body calls `fatalError`.
///
/// This hack is necessary because, while `ForEach` does not require that its `Content` be a `View`,
/// there are no ways for me to initialize one otherwise. I wish this didn't have to exist.
@MainActor
public struct _CustomTabContentView<Value: Hashable>: View {
    internal init(tabContent: any CustomTabContent<Value>) {
        self.tabContent = tabContent
    }
    
    internal let tabContent: any CustomTabContent<Value>
    
    /// This property is private. Do not use it, as it calls `fatalError`.
    @_spi(Hidden)
    public var body: some View {
        fatalError("_CustomTabContentView is not intended to be instantiated directly.")
    }
}
