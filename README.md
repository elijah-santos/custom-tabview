#  custom-tabview

## SwiftUI's `TabView` with greater customization

`custom-tabview` is a library providing a (mostly) drop-in replacement for SwiftUI's new-style
`TabView` initializers, allowing for custom styling. 

## Usage

*TL;DR: Just replace usage of `TabView` et al. with `CustomTabView`, `CustomTab`, etc.*

Using this library is as simple as it sounds:
```swift
import CustomTabView

struct ContentView: View {
    var body: some View {
        CustomTabView {
            CustomTab("A", systemImage: "a.circle") { ... }
            CustomTab("B", systemImage: "b.circle") { ... }
            CustomTabSection("Contrived Examples") {
                CustomTab("C", systemImage: "c.circle") { ... }
                CustomTab("D (custom image)", image: "my-image-resource") { ... }
                CustomTab("E (no image)") { ... }
            }
        }
    }
}
```

Just add a Swift package dependency, import the library, and make your views.

### Details

In this library, the following SwiftUI types have direct analogues:
- `TabView -> CustomTabView`
- `Tab -> CustomTab`
- `TabSection -> CustomTabSection`
- `TabContent -> CustomTabContent`
- `TabContentBuilder -> CustomTabContentBuilder`

`CustomTabView` has an initializer that takes a `Binding<some Hashable>` and one that does not. If
you provide a selection binding, your tab content (as in SwiftUI) must provide a value of that type.
In this case, you can modify and observe changes to the selection. If you opt not to provide this
binding, the library handles selection for you and you must not provide values for each tab. Note
that, due to quirks of the implementation (see the Quirks & Caveats section), if your tab content
changes over time (tabs being inserted or removed), I advise you use the overload that takes a 
selection.

As in SwiftUI with `TabView` and `TabContentBuilder<T>`, `CustomTabView` takes a closure annotated
with `CustomTabContentBuilder<T>` that produces `CustomTabContent`. `CustomTab` and 
`CustomTabSection` both conform to `CustomTabContent`, but you can define your own types to conform
also by implementing the `body` property. If you do so, keep in mind the generic parameter:
```swift
struct ContrivedExample: CustomTabContent {
    var body: some CustomTabContent<Never> {
        // note that the Never on the above line is necessary for this to compile
        // since this is a CustomTab with no value, ContrivedExample is CustomTabContent<Never>
        CustomTab("Something") { ... }
    }
}
```

In order to customize the appearance and behavior of a `CustomTabView`, define a type conforming to
`CustomTabViewStyle` and pass it to the `.customTabViewStyle(_:)` method on `View`. This protocol
has a single requirement, `makeBody(configuration:)` which returns the view to be drawn. For
clarity, it is generally advisable to create a static property on `CustomTabViewStyle`. The library
provides one such static property `.native`, which defers to SwiftUI's `TabView`, which is the
default behavior. If using `.native` style, you can use `.tabViewStyle(_:)` to customize the
underlying SwiftUI `TabView`.

A basic implementation of `CustomTabViewStyle` might look like this:

```swift
struct ExampleStyle: CustomTabViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            VStack {
                ForEach(configuration.items) { item in
                    switch item {
                    case .section(let section):
                        GroupBox {
                            // ignore nested tab sections by using section.tabs
                            ForEach(section.tabs) { tab in
                                tab.label
                                    .foregroundStyle(tab.selected ? .blue : .primary)
                                    .onTapGesture {
                                        tab.select()
                                    }
                            }
                        } label: {
                            section.label
                        }
                    case .tab(let tab):
                        tab.label
                            .foregroundStyle(tab.selected ? .blue : .primary)
                            .onTapGesture {
                                tab.select()
                            }
                    }
                }
            }
            Divider()
            configuration.selectedTab?.content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

extension CustomTabViewStyle where Self == ExampleStyle {
    static var example: Self { .init() }
}
```

All public types in this library should be documented, so for specific information, check the
type-level documentation.

## Quirks & Caveats

Being that this library is effectively a reimplementation of SwiftUI's `TabView`, it has a few
quirks.

1. This library doesn't provide all of the same initializers as SwiftUI's `Tab` and `TabSection`.
   For example, custom labels (beyond a title and, optionally, an image) are not currently supported
   though I plan on incorporaring this eventually.
1. This library does not handle changing tab content quite as well as SwiftUI does natively,
   especially if `CustomTabView.init(content:)` is used (i.e., no selection binding). This may lead
   to weird animation behavior.
1. When the content of a `CustomTabView` changes, if no tab is left that matches the current
   selection, `CustomTabView` *does not* automatically select a new tab.
1. This library does not support `TabCustomization` et al. 
1. This library uses 2 underscored Swift attributes: `@_spi` and `@_disfavoredOverload`. While these
   are technically private attributes, they are widely used in existing Swift code (including 
   SwiftUI itself) and are likely okay to use. Note that `@_spi` is not used to call into any actual
   SPI, rather, it is used to hide some implementation details from you, the developer. For this
   reason, I consider this use of the attribute acceptable as there is no reliance on any 
   implementation details of SwiftUI.
