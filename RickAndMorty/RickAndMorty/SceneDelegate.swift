import UIKit
import CommonUI
import Foundation
import RestNetworking
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var charactersCoordinator: CharactersCoordinator?
    private let navigationController: UINavigationController = UINavigationController()
    
    internal func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        migrateRealm()
        window = UIWindow(windowScene: windowScene)
        
        window?.rootViewController = navigationController
        
        let networkingClient = AlamofireClient(retryLimit: 3)
        let cacheClient = CharactersCacheServiceImplementation()
        charactersCoordinator = CharactersCoordinator(navigationController: self.navigationController,
                                                      networkingClient: networkingClient,
                                                      cacheClient: cacheClient)
        window?.makeKeyAndVisible()
        charactersCoordinator?.start()
    }
    
    private func migrateRealm() {
        // Define your Realm configuration
        let config = Realm.Configuration(
            schemaVersion: 2, // Increment this each time you make a change to the schema
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    // Handle migrations for versions before 2 (where new properties were added)
                    migration.enumerateObjects(ofType: RealmCharacter.className()) { oldObject, newObject in
                        // You can provide default values for new properties if needed
                        newObject?["origin"] = "" // Set a default value for the new property 'origin'
                        newObject?["location"] = "" // Set a default value for the new property 'location'
                        newObject?["image"] = "" // Set a default value for the new property 'image'
                    }
                }
            }
        )

        // Set the new configuration as the default configuration for Realm
        Realm.Configuration.defaultConfiguration = config
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called when the scene is released by the system
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background
    }
}
