//
// Statio
// Varun Santhanam
//

import Foundation
import UIKit

struct MainTabViewModel: Equatable, Hashable {

    // MARK: - API

    let title: String
    let image: UIImage?
    let tag: Int

    // MARK: - Equatable

    public static func == (lhs: MainTabViewModel, rhs: MainTabViewModel) -> Bool {
        lhs.title == rhs.title && lhs.tag == rhs.tag && lhs.image == rhs.image
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(tag)
        hasher.combine(image)
    }
}
