//
// Statio
// Varun Santhanam
//

import Foundation
import NeedleFoundation
import ShortRibs

protocol MapDependency: Dependency {}

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
        let viewController = MapViewController()
        let interactor = MapInteractor(presenter: viewController)
        interactor.listener = listener
        return interactor
    }

    // MARK: - MapBuildable

    func build(withListener listener: MapListener) -> PresentableInteractable {
        build(withDynamicBuildDependency: listener)
    }

}
