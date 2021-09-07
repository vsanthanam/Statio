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
         memoryListDataSource: MemoryListDataSource,
         byteFormatter: ByteFormatting) {
        self.analyticsManager = analyticsManager
        collectionView = memoryListCollectionView
        dataSource = memoryListDataSource
        self.byteFormatter = byteFormatter
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
            .legendEntry("Total", byteFormatter.formattedBytesForMemory(snapshot.physical)),
            .legendEntry("Free", byteFormatter.formattedBytesForMemory(snapshot.free)),
            .legendEntry("Reserved", byteFormatter.formattedBytesForMemory(snapshot.reserved)),
            .legendEntry("Used", byteFormatter.formattedBytesForMemory(snapshot.used))
        ], toSection: .overview)
        dataSnapshot.appendItems([.legendEntry("Active", byteFormatter.formattedBytesForMemory(snapshot.active)),
                                  .legendEntry("Inactive", byteFormatter.formattedBytesForMemory(snapshot.inactive)),
                                  .legendEntry("Wired", byteFormatter.formattedBytesForMemory(snapshot.wired))],
                                 toSection: .usageBreakdown)
        let offset = collectionView.contentOffset
        dataSource.apply(dataSnapshot)
        collectionView.contentOffset = offset
    }

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging
    private let collectionView: MemoryListCollectionViewable
    private let dataSource: MemoryListDataSource
    private let byteFormatter: ByteFormatting

    @objc
    private func didTapBack() {
        analyticsManager.send(event: AnalyticsEvent.memory_vc_dismiss)
        listener?.didTapBack()
    }
}
