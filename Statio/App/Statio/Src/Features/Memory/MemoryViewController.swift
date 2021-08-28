//
// Statio
// Varun Santhanam
//

import Analytics
import Charts
import Foundation
import ShortRibs
import StatioKit
import UIKit

/// @mockable
protocol MemoryViewControllable: ViewControllable {}

/// @mockable
protocol MemoryPresentableListener: AnyObject {
    func didTapBack()
}

final class MemoryViewController: ScopeViewController, MemoryPresentable, MemoryViewControllable, UICollectionViewDelegate {

    // MARK: - Initializers

    init(analyticsManager: AnalyticsManaging,
         memoryListCollectionView: MemoryListCollectionViewable,
         memoryListDataSource: MemoryListDataSource) {
        self.analyticsManager = analyticsManager
        collectionView = memoryListCollectionView
        dataSource = memoryListDataSource
        super.init()
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Memory"
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
        analyticsManager.send(event: AnalyticsEvent.memory_vc_impression)
    }

    // MARK: - MemoryPresentable

    weak var listener: MemoryPresentableListener?

    func present(snapshot: MemorySnapshot) {
        var dataSnapshot = NSDiffableDataSourceSnapshot<MemoryListSection, MemoryListRow>()
        dataSnapshot.appendSections([.pressureChart,
                                     .overview,
                                     .usageBreakdown])
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        dataSnapshot.appendItems([.chartData([
            ("Wired", snapshot.wired),
            ("Active", snapshot.active),
            ("Inactive", snapshot.inactive),
            ("Reserved", snapshot.reserved),
            ("Free", snapshot.free)
        ])], toSection: .pressureChart)
        dataSnapshot.appendItems([
            .legendEntry("Total", snapshot.physical.asCountedMemory),
            .legendEntry("Free", snapshot.free.asCountedMemory),
            .legendEntry("Reserved", snapshot.reserved.asCountedMemory),
            .legendEntry("Used", snapshot.used.asCountedMemory)
        ], toSection: .overview)
        dataSnapshot.appendItems([.legendEntry("Active", snapshot.active.asCountedMemory),
                                  .legendEntry("Inactive", snapshot.inactive.asCountedMemory),
                                  .legendEntry("Wired", snapshot.wired.asCountedMemory)],
                                 toSection: .usageBreakdown)
        let offset = collectionView.contentOffset
        dataSource.apply(dataSnapshot)
        collectionView.contentOffset = offset
    }

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging
    private let collectionView: MemoryListCollectionViewable
    private let dataSource: MemoryListDataSource

    @objc
    private func didTapBack() {
        analyticsManager.send(event: AnalyticsEvent.memory_vc_dismiss)
        listener?.didTapBack()
    }
}
