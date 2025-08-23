import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Root = UINavigationController(Login)
        let login = LoginViewController()
        let nav = UINavigationController(rootViewController: login)

        // עיצוב הניווט לגרייסקייל כהה
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColors.bg
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.shadowColor = .clear

        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
        nav.navigationBar.compactAppearance = appearance
        nav.navigationBar.tintColor = .white              // צבע כפתורי back וכו'
        nav.navigationBar.barStyle = .black               // סטטוס-בר בהיר (טקסט לבן)
        nav.navigationBar.prefersLargeTitles = false
        login.navigationItem.backButtonTitle = ""         // חץ אחורה ללא טקסט כברירת מחדל

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = nav
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
