import UIKit
import Lottie

class HomeViewController: UIViewController {
    
    // 🧍 Welcome Card
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray3.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.circle.fill")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 30
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, User!"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "User Type"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 🔄 Lottie Loader
    private var loadingAnimation: LottieAnimationView = {
        let anim = LottieAnimationView(name: "loading_animation")
        anim.loopMode = .loop
        anim.isHidden = true
        anim.translatesAutoresizingMaskIntoConstraints = false
        return anim
    }()
    
    // 📢 Ads Pager
    private let adsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 80, height: 200)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.96, alpha: 1.0) // #F5F5F5
        setupLayout()
        
        // דוגמא: התחלת טעינה
        // showLoading(true)
    }
    
    private func setupLayout() {
        view.addSubview(cardView)
        cardView.addSubview(profileImageView)
        cardView.addSubview(userNameLabel)
        cardView.addSubview(userTypeLabel)
        view.addSubview(loadingAnimation)
        view.addSubview(adsCollectionView)
        
        // 📌 Card Layout
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            profileImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            profileImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),
            
            userNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            userNameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            userTypeLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            userTypeLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 4),
            userTypeLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            userTypeLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
        
        // 🔄 Loader Layout
        NSLayoutConstraint.activate([
            loadingAnimation.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 24),
            loadingAnimation.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingAnimation.widthAnchor.constraint(equalToConstant: 150),
            loadingAnimation.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        // 📢 Ads
        NSLayoutConstraint.activate([
            adsCollectionView.topAnchor.constraint(equalTo: loadingAnimation.bottomAnchor, constant: 24),
            adsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            adsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            adsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
    
    // פונקציה להראות/להסתיר אנימציה
    func showLoading(_ show: Bool) {
        loadingAnimation.isHidden = !show
        if show {
            loadingAnimation.play()
        } else {
            loadingAnimation.stop()
        }
    }
}
