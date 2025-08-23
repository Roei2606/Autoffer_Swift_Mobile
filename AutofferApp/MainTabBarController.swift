import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 🏠 Home
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Home",
                                         image: UIImage(named: "ic_home"),
                                         tag: 0)

        // 💬 Chats
        let chatsVC = ChatsViewController()
        chatsVC.tabBarItem = UITabBarItem(title: "Chats",
                                          image: UIImage(named: "ic_chats"),
                                          tag: 1)

        // ➕ New Project
        let newProjectVC = NewProjectViewController()
        newProjectVC.tabBarItem = UITabBarItem(title: "New Project",
                                               image: UIImage(named: "ic_add_project"),
                                               tag: 2)

        // 📁 My Projects
        let myProjectsVC = ProjectsViewController()
        myProjectsVC.tabBarItem = UITabBarItem(title: "My Projects",
                                               image: UIImage(named: "ic_my_projects"),
                                               tag: 3)

        // 🏭 Factories
        let factoriesVC = UserDirectoryViewController()
        factoriesVC.tabBarItem = UITabBarItem(title: "Factories",
                                              image: UIImage(named: "ic_factories"),
                                              tag: 4)

        // הכנסת כל הטאבים
        self.viewControllers = [
            UINavigationController(rootViewController: homeVC),
            UINavigationController(rootViewController: chatsVC),
            UINavigationController(rootViewController: newProjectVC),
            UINavigationController(rootViewController: myProjectsVC),
            UINavigationController(rootViewController: factoriesVC)
        ]
    }
}
