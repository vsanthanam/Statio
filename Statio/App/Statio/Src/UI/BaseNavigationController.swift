//
// Statio
// Varun Santhanam
//

import Foundation
import UIKit

open class BaseNavigationController: UINavigationController {

    override public init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Don't Use Interface Builder 😡")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UINavigationBarAppearance()
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.contentPrimary]
//        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.contentPrimary]
//        appearance.backgroundColor = .backgroundPrimary
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.prefersLargeTitles = true
//        navigationBar.tintColor = .contentAccentPrimary
    }

}
