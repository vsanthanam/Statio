//
// Statio
// Varun Santhanam
//

import Foundation
import UIKit

struct MainTabViewModel: Equatable, Hashable {
    let title: String
    let image: UIImage?
    let tag: Int

    public static func == (lhs: MainTabViewModel, rhs: MainTabViewModel) -> Bool {
        lhs.title == rhs.title && lhs.tag == rhs.tag && lhs.image == rhs.image
    }
}
