//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs
import UIKit

class BaseNavigationController: UINavigationController {

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }

    init() {
        super.init(rootViewController: .init())
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Don't Use Interface Builder 😡")
    }

    override func viewDidLoad() {
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

extension BaseNavigationController: ViewControllable {
    var uiviewController: UIViewController { self }
}
