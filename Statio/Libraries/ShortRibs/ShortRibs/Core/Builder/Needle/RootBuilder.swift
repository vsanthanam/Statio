//
// Aro
// Varun Santhanam
//

import Foundation
import NeedleFoundation

public protocol RootComponent: BootstrapComponent {
    associatedtype Dependency
    init(dynamicDependency: Dependency)
}

public extension RootComponent where Dependency == Void {
    init() {
        self.init(dynamicDependency: ())
    }
}

open class ComponentizedRootBuilder<Component, Interactable, DynamicBuildDependency, DynamicComponentDependency>: ComponentizedBuilder<Component, Interactable, DynamicBuildDependency, DynamicComponentDependency> where Component: RootComponent, Component.Dependency == DynamicComponentDependency {

    public init() {
        super.init { dependency in
            .init(dynamicDependency: dependency)
        }
    }

    @available(*, unavailable)
    public required init(componentBuilder: @escaping ComponentBuilder) {
        fatalError("RootComponent provides its own component & parent")
    }
}

open class SimpleRootBuilder<Component, Interactable>: SimpleComponentizedBuilder<Component, Interactable> where Component: RootComponent, Component.Dependency == Void {
    public init() {
        super.init { dependency in
            .init(dynamicDependency: dependency)
        }
    }

    @available(*, unavailable)
    public required init(componentBuilder: @escaping ComponentBuilder) {
        fatalError("RootComponent provides its own component & parent")
    }
}

open class MultiStageRootBuilder<Component, Interactable, DynamicBuildDependency>: MultiStageBuilder<Component, Interactable, DynamicBuildDependency> where Component: RootComponent, Component.Dependency == Void {

    public init() {
        super.init {
            .init()
        }
    }

    @available(*, unavailable)
    public required init(componentBuilder: @escaping ComponentBuilder) {
        fatalError("RootComponent provides its own component & parent")
    }

}

open class SimpleMultiStageRootBuilder<Component, Interactable>: SimpleMultiStageBuilder<Component, Interactable> where Component: RootComponent, Component.Dependency == Void {

    public init() {
        super.init {
            .init()
        }
    }

    @available(*, unavailable)
    public required init(componentBuilder: @escaping ComponentBuilder) {
        fatalError("RootComponent provides its own component & parent")
    }
}
