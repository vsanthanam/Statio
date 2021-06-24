//
// Statio
// Varun Santhanam
//

import Analytics
import CoreData
import Logging
import NeedleFoundation
import os.log
import ShortRibs
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - UIApplicationDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        startAnalytics()
        registerProviderFactories()
        AnalyticsManager.shared.start(trace: AnalyticsTrace.app_launch)
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        .init(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - API

    static var shared: AppDelegate {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Invalid App Delegate Class")
        }
        return delegate
    }

    // MARK: - Private

    private func startAnalytics() {
        do {
            guard let file = Bundle.main.url(forResource: "analytics_config", withExtension: "json") else {
                fatalError("""
                Fatal: Invalid Analytics Configuration Resource
                Run `./dasut bootstrap` and regenerate the project
                """)
            }
            let data = try Data(contentsOf: file)
            let config = try JSONDecoder().decode(AnalyticsManager.Configuration.self, from: data)
            if let urlString = config.host {
                if let url = URL(string: urlString) {
                    os_log("Starting analytics on host: %{public}@", log: .standard, type: .info, url.description)
                } else {
                    fatalError("Invalid Host Url \(urlString)!")
                }
            }
            AnalyticsManager.shared.eventPrefix = "statio_"
            AnalyticsManager.shared.startAnalytics(with: config)
        } catch {
            fatalError("Broken Analytics Configuration: \(error.localizedDescription)")
        }
    }
}
