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
    public private(set) var wrappedValue: Void = ()
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
public extension SwiftUI.View {
    @propertyWrapper
    public struct Injection {
        public private(set) var wrappedValue: Void = ()
    }
    @inlinable @inline(__always)
    func enableInjection() -> some SwiftUI.View { self }
    @inlinable @inline(__always)
    func enableInjection(callback: @escaping (Self) -> Void) -> some SwiftUI.View {
        self
    }
}
#endif
