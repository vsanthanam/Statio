//
// Statio
// Varun Santhanam
//

#if canImport(CoreData)

    import CoreData
    import Foundation

    /// @CreateMock
    public protocol PersistentContaining: AnyObject {
        var name: String { get }
        var managedObejctModel: NSManagedObjectModel { get }
        var persistentStoreCoordinator: NSPersistentStoreCoordinator { get }
        var viewContext: NSManagedObjectContext { get }
        func createBackgroundContext() -> NSManagedObjectContext
        func saveContext() throws
    }

    public class PersistentContainer: PersistentContaining {
        // MARK: - Initializers

        public init(_ container: NSPersistentContainer) {
            self.container = container
        }

        // MARK: - PersistentContaining

        public var name: String {
            container.name
        }

        public var managedObejctModel: NSManagedObjectModel {
            container.managedObjectModel
        }

        public var persistentStoreCoordinator: NSPersistentStoreCoordinator {
            container.persistentStoreCoordinator
        }

        public func createBackgroundContext() -> NSManagedObjectContext {
            container.newBackgroundContext()
        }

        public var viewContext: NSManagedObjectContext {
            container.viewContext
        }

        public func saveContext() throws {
            let context = container.viewContext
            if context.hasChanges {
                try context.save()
            }
        }

        // MARK: - Private

        private let container: NSPersistentContainer
    }

#endif
