//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs
import UIKit

/// @mockable
protocol DiskListCollectionViewable: Viewable {
    var contentOffset: CGPoint { get set }
    var delegate: UICollectionViewDelegate? { get set }
}

final class DiskListCollectionView: UICollectionView, DiskListCollectionViewable {

    init() {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.showsSeparators = true
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        super.init(frame: .zero, collectionViewLayout: layout)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
