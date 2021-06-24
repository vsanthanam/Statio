//
// Statio
// Varun Santhanam
//

import Foundation

open class MultiStageBuilder<Component, Interactor, DynamicBuildDependency>: Buildable {

    // MARK: - Initializer

    public required init(componentBuilder: @escaping ComponentBuilder) {
        self.componentBuilder = componentBuilder
    }

    // MARK: - API

    public typealias ComponentBuilder = () -> Component

    public var componentForCurrentBuildPass: Component {
        if let currentComponent = currentComponent {
            return currentComponent
        } else {
            let currentComponent = componentBuilder()
            let newComponent = currentComponent as AnyObject
            assert(lastComponent !== newComponent, "\(self) componentBuilder should produce new instances of component when build is invoked.")
            lastComponent = newComponent
            self.currentComponent = currentComponent
            return currentComponent
        }
    }

    open func finalStageBuild(with component: Component, _ dynamicDependency: DynamicBuildDependency) -> Interactor {
        fatalError("Abstract Method Not Implemented!")
    }

    public final func finalStageBuild(withDynamicDependency dynamicDependency: DynamicBuildDependency) -> Interactor {
        let interactor = finalStageBuild(with: componentForCurrentBuildPass, dynamicDependency)
        defer {
            currentComponent = nil
        }
        return interactor
    }

    // MARK: - Private

    private let componentBuilder: ComponentBuilder
    private var currentComponent: Component?
    private weak var lastComponent: AnyObject?
}

open class SimpleMultiStageBuilder<Component, Interactor>: MultiStageBuilder<Component, Interactor, Void> {

    // MARK: - API

    open func finalStageBuild(with component: Component) -> Interactor {
        fatalError("Abstract Method Not Implemented!")
    }

    public final func finalStageBuild() -> Interactor {
        finalStageBuild(withDynamicDependency: ())
    }

    // MARK: - MuliStageBuilder

    override public func finalStageBuild(with component: Component, _ dynamicDependency: Void) -> Interactor {
        finalStageBuild(with: component)
    }

}
