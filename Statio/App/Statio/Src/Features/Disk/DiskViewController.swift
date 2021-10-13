//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import ShortRibs
import UIKit

/// @CreateMock
protocol DiskViewControllable: ViewControllable {}

/// @CreateMock
protocol DiskPresentableListener: AnyObject {
    func didTapBack()
}

final class DiskViewController: ScopeViewController, DiskPresentable, DiskViewControllable, UICollectionViewDelegate {

    // MARK: - Initializer

    init(analyticsManager: AnalyticsManaging,
         diskListCollectionView: DiskListCollectionViewable,
         diskListDataSource: DiskListDataSource,
         byteFormatter: ByteFormatting) {
        self.analyticsManager = analyticsManager
        collectionView = diskListCollectionView
        dataSource = diskListDataSource
        self.byteFormatter = byteFormatter
        super.init()
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Disk"
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
        analyticsManager.send(event: AnalyticsEvent.disk_vc_impression)
    }

    // MARK: - DiskPresentable

    weak var listener: DiskPresentableListener?

    func present(snapshot: DiskSnapshot) {
        var dataSnapshot = NSDiffableDataSourceSnapshot<DiskListSection, DiskListRow>()
        dataSnapshot.appendSections([.overview,
                                     .availabilityBreakdown])
        dataSnapshot.appendItems([
            .legendEntry("Total", byteFormatter.formattedBytesForDisk(snapshot.total)),
            .legendEntry("Available", byteFormatter.formattedBytesForDisk(snapshot.available)),
            .legendEntry("Used", byteFormatter.formattedBytesForDisk(snapshot.total - snapshot.available))
        ], toSection: .overview)
        dataSnapshot.appendItems([.legendEntry("Available Now", byteFormatter.formattedBytesForDisk(snapshot.opportunisticAvailable)),
                                  .legendEntry("Available If Needed", byteFormatter.formattedBytesForDisk(snapshot.importantAvailable))],
                                 toSection: .availabilityBreakdown)
        let offset = collectionView.contentOffset
        dataSource.apply(dataSnapshot)
        collectionView.contentOffset = offset
    }

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging
    private let collectionView: DiskListCollectionViewable
    private let dataSource: DiskListDataSource
    private let byteFormatter: ByteFormatting

    @objc
    private func didTapBack() {
        analyticsManager.send(event: AnalyticsEvent.disk_vc_dismiss)
        listener?.didTapBack()
    }
}
