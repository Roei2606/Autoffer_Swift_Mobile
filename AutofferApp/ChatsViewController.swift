import UIKit
import Lottie

class ChatsViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIStackView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Chats"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .black
        return label
    }()

    private let loadingAnimation: LottieAnimationView = {
        let animation = LottieAnimationView(name: "loading_animation")
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.isHidden = true
        return animation
    }()

    private let noChatsLabel: UILabel = {
        let label = UILabel()
        label.text = "No chats"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.isHidden = true
        return label
    }()

    private let tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.isHidden = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.96, alpha: 1.0) // #F5F5F5
        setupLayout()
    }

    private func setupLayout() {
        // ScrollView
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Content Stack
        scrollView.addSubview(contentView)
        contentView.axis = .vertical
        contentView.alignment = .center
        contentView.spacing = 16
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        // Add subviews
        contentView.addArrangedSubview(titleLabel)

        contentView.addArrangedSubview(loadingAnimation)
        NSLayoutConstraint.activate([
            loadingAnimation.widthAnchor.constraint(equalToConstant: 150),
            loadingAnimation.heightAnchor.constraint(equalToConstant: 150)
        ])

        contentView.addArrangedSubview(noChatsLabel)

        contentView.addArrangedSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(equalToConstant: 400),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    // 🔄 פונקציות לדוגמה
    func showLoading(_ show: Bool) {
        loadingAnimation.isHidden = !show
        if show { loadingAnimation.play() } else { loadingAnimation.stop() }
    }

    func showNoChats(_ show: Bool) {
        noChatsLabel.isHidden = !show
    }
}
