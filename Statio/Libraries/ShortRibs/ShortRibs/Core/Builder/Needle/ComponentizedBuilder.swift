//
// Statio
// Varun Santhanam
//

import Foundation

open class ComponentizedBuilder<Component, Interactor, DynamicBuildDependency, DynamicComponentDependency>: Buildable {

    // MARK: - Initializers

    public required init(componentBuilder: @escaping ComponentBuilder) {
        self.componentBuilder = componentBuilder
    }

    // MARK: - API

    public typealias ComponentBuilder = (DynamicComponentDependency) -> Component

    open func build(with component: Component, _ dynamicBuildDependency: DynamicBuildDependency) -> Interactor {
        fatalError("Abstract Method Not Implemented!")
    }

    public final func build(withDynamicBuildDependency dynamicBuildDependency: DynamicBuildDependency,
                            dynamicComponentDependency: DynamicComponentDependency) -> Interactor {
        build(withDynamicBuildDependency: dynamicBuildDependency,
              dynamicComponentDependency: dynamicComponentDependency).1
    }

    public final func build(withDynamicBuildDependency dynamicBuildDependency: DynamicBuildDependency,
                            dynamicComponentDependency: DynamicComponentDependency) -> (Component, Interactor) {
        let component = componentBuilder(dynamicComponentDependency)
        let newComponent = component as AnyObject
        assert(lastComponent !== newComponent, "componentBuilder should produce new instances of component when build is invoked")
        lastComponent = newComponent

        return (component, build(with: component, dynamicBuildDependency))
    }

    // MARK: - Private

    private weak var lastComponent: AnyObject?
    private let componentBuilder: ComponentBuilder

}

open class SimpleComponentizedBuilder<Component, Interactor>: ComponentizedBuilder<Component, Interactor, Void, Void> {

    // MARK: - API

    open func build(with component: Component) -> Interactor {
        fatalError("Abstract Method Not Implemented!")
    }

    // MARK: - ComponentizedBuilder

    override public final func build(with component: Component, _ dynamicBuildDependency: Void) -> Interactor {
        build(with: component)
    }
}

public extension ComponentizedBuilder where DynamicBuildDependency == Void {
    final func build(withDynamicComponentDependencya dynamicComponentDependency: DynamicComponentDependency) -> Interactor {
        build(withDynamicBuildDependency: (), dynamicComponentDependency: dynamicComponentDependency)
    }
}

public extension ComponentizedBuilder where DynamicComponentDependency == Void {
    final func build(withDynamicBuildDependency dynamicBuildDependency: DynamicBuildDependency) -> Interactor {
        build(withDynamicBuildDependency: dynamicBuildDependency, dynamicComponentDependency: ())
    }
}

public extension ComponentizedBuilder where DynamicBuildDependency == Void, DynamicComponentDependency == Void {
    final func build() -> Interactor {
        build(withDynamicBuildDependency: (),
              dynamicComponentDependency: ())
    }
}
