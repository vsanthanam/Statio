//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import ShortRibs
import SnapKit
import UIKit

/// @CreateMock
protocol DeviceIdentityViewControllable: ViewControllable {}

/// @CreateMock
protocol DeviceIdentityPresentableListener: AnyObject {
    func didTapBack()
}

final class DeviceIdentityViewController: ScopeViewController, DeviceIdentityPresentable, DeviceIdentityViewControllable, UICollectionViewDelegate {

    // MARK: - Initializers

    init(analyticsManager: AnalyticsManaging,
         collectionView: DeviceIdentityCollectionViewable,
         dataSource: DeviceIdentityDataSource) {
        self.analyticsManager = analyticsManager
        self.collectionView = collectionView
        self.dataSource = dataSource
        super.init()
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
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
        analyticsManager.send(event: AnalyticsEvent.device_identity_vc_impression)
    }

    // MARK: - DeviceIdentityPresentable

    weak var listener: DeviceIdentityPresentableListener?

    func apply(viewModel: DeviceIdentityViewModel) {
        title = viewModel.deviceName
        var snapshot = NSDiffableDataSourceSnapshot<DeviceIdentityCategory, DeviceIdentityRow>()
        snapshot.appendSections([.hardware, .software])
        snapshot.appendItems([.init(title: "Model Name", value: viewModel.modelName),
                              .init(title: "Model Identifier", value: viewModel.modelIdentifier)],
                             toSection: .hardware)
        snapshot.appendItems([.init(title: "Operating System", value: viewModel.osName)])
        snapshot.appendItems([.init(title: "Version", value: viewModel.osVersion)],
                             toSection: .software)
        dataSource.apply(snapshot)
    }

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging
    private let collectionView: DeviceIdentityCollectionViewable
    private let dataSource: DeviceIdentityDataSource

    @objc
    private func didTapBack() {
        analyticsManager.send(event: AnalyticsEvent.device_identity_vc_dismiss)
        listener?.didTapBack()
    }
}
