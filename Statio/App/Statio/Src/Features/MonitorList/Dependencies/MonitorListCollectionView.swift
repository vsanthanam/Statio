//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs
import UIKit

/// @mockable
protocol MonitorListCollectionView: Viewable {
    var delegate: UICollectionViewDelegate? { get set }
}

extension UICollectionView: MonitorListCollectionView {
    var uiview: UIView { self }
}
