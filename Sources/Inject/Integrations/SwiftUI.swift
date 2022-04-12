import Foundation
import SwiftUI

#if DEBUG
@propertyWrapper
public struct Injection: DynamicProperty {
    @ObservedObject private var iO = Inject.observer
    public init(animation: Animation? = nil) {
        _ = Inject.load
        Inject.animation = animation
    }
    public private(set) var wrappedValue: Inject.Type = Inject.self
}
public extension SwiftUI.View {
    func enableInjection() -> some SwiftUI.View { AnyView(self) }
    func enableInjection(callback: @escaping (Self) -> Void) -> some SwiftUI.View {
        AnyView(self.onReceive(Inject.observer.objectWillChange, perform: {
            callback(self)
        }))
    }
}

#else
@propertyWrapper
public struct Injection {
    public init(animation: @autoclosure () -> Animation? = nil) { }
    public let wrappedValue = 0
}
public extension SwiftUI.View {
    @inlinable @inline(__always)
    func enableInjection() -> Self { self }
    @inlinable @inline(__always)
    func enableInjection(callback: @escaping (Self) -> Void) -> Self {
        self
    }
}
#endif
