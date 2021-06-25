//
// Statio
// Varun Santhanam
//

import Foundation
import UIKit

extension UIImage {
    func imageWith(newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let image = renderer.image { _ in
            self.draw(in: .init(origin: .zero, size: newSize))
        }

        return image
    }

    var tabBarSized: UIImage {
        imageWith(newSize: .init(width: 23.0, height: 23.0))
    }
}
