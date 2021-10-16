//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import MonitorKit
import ShortRibs
import SnapKit
import UIKit

/// @CreateMock
protocol BatteryViewControllable: ViewControllable {}

/// @CreateMock
protocol BatteryPresentableListener: AnyObject {
    func didTapBack()
}

final class BatteryViewController: ScopeViewController, BatteryPresentable, BatteryViewControllable, UICollectionViewDelegate {

    // MARK: - Initializers

    init(analyticsManager: AnalyticsManaging,
         collectionView: BatteryCollectionViewable,
         dataSource: BatteryDataSource) {
        self.analyticsManager = analyticsManager
        self.collectionView = collectionView
        self.dataSource = dataSource
        super.init()
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Battery"
        let leadingItem = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(didTapBack))
        navigationItem.leftBarButtonItem = leadingItem
        specializedView.backgroundColor = .systemBackground
        collectionView.delegate = self
        specializedView.addSubview(collectionView.uiview)
        collectionView.uiview.snp.makeConstraints { make in
            make
                .edges
                .equalToSuperview()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsManager.send(event: AnalyticsEvent.battery_vc_impression)
    }

    // MARK: - BatteryPresentable

    weak var listener: BatteryPresentableListener?

    func update(level: Battery.Level) {
        self.level = level
        reload()
    }

    func update(state: Battery.State) {
        self.state = state
        reload()
    }

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging
    private let collectionView: BatteryCollectionViewable
    private let dataSource: BatteryDataSource
    private var level: Battery.Level?
    private var state: Battery.State?

    private func reload() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, BatteryRow>()
        snapshot.appendSections([0])
        snapshot.appendItems([.init(title: "Level", value: level.map(\.description) ?? "Unknown"),
                              .init(title: "State", value: state.map(\.userDescription) ?? "Unknown")],
                             toSection: 0)
        dataSource.apply(snapshot)
    }

    @objc
    private func didTapBack() {
        analyticsManager.send(event: AnalyticsEvent.battery_vc_dismiss)
        listener?.didTapBack()
    }
}

private extension Battery.State {

    var userDescription: String {
        switch self {
        case .charging:
            return "Charging"
        case .discharging:
            return "Discharging"
        case .full:
            return "Full"
        case .unknown:
            return "Unknown"
        }
    }

}
