import UIKit
import CommonUI
import Foundation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var charactersCoordinator: CharactersCoordinator?
    private let navigationController: UINavigationController = UINavigationController()
    
    internal func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        window?.rootViewController = navigationController
        charactersCoordinator = CharactersCoordinator(navigationController: self.navigationController,
                                                      networkingClient: NetworkingClientMock())
        window?.makeKeyAndVisible()
        charactersCoordinator?.start()
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
