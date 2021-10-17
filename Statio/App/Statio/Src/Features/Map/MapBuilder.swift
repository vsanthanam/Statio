//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import NeedleFoundation
import ShortRibs

protocol MapDependency: Dependency {
    var analyticsManager: AnalyticsManaging { get }
}

class MapComponent: Component<MapDependency> {}

/// @CreateMock
protocol MapInteractable: PresentableInteractable {}

typealias MapDynamicBuildDependency = (
    MapListener
)

/// @CreateMock
protocol MapBuildable: AnyObject {
    func build(withListener listener: MapListener) -> PresentableInteractable
}

final class MapBuilder: ComponentizedBuilder<MapComponent, PresentableInteractable, MapDynamicBuildDependency, Void>, MapBuildable {

    // MARK: - ComponentizedBuilder

    override func build(with component: MapComponent, _ dynamicBuildDependency: MapDynamicBuildDependency) -> PresentableInteractable {
        let listener = dynamicBuildDependency
        let viewController = MapViewController(analyticsManager: component.analyticsManager)
        let interactor = MapInteractor(presenter: viewController)
        interactor.listener = listener
        return interactor
    }

    // MARK: - MapBuildable

    func build(withListener listener: MapListener) -> PresentableInteractable {
        build(withDynamicBuildDependency: listener)
    }

}
