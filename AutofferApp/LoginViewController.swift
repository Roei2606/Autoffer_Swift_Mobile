import UIKit

final class LoginViewController: UIViewController {

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Login"
        l.textColor = AppColors.white
        l.font = AppFont.title()
        return l
    }()

    private let emailField = FilledTextField(placeholder: "Email", kind: .normal)
    private let passwordField = FilledTextField(placeholder: "Password", kind: .password(showToggle: true))

    private let forgotPassword: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Forgot password?", for: .normal)
        b.setTitleColor(AppColors.hint, for: .normal)
        b.titleLabel?.font = AppFont.small()
        b.contentHorizontalAlignment = .right
        return b
    }()

    private let loginButton = PrimaryWhiteButton(title: "Login")

    private let registerLink: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Don't have an account? Register", for: .normal)
        b.setTitleColor(AppColors.hint, for: .normal)
        b.titleLabel?.font = UIFont.italicSystemFont(ofSize: 14)
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.bg

        // חיווטי לחיצה
        registerLink.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        forgotPassword.addTarget(self, action: #selector(didTapForgot), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)

        // Stack אנכי לכל התוכן – יציב ופשוט ל-hit-testing
        let vstack = UIStackView(arrangedSubviews: [
            titleLabel,
            emailField,
            passwordField,
            forgotPassword,
            loginButton,
            registerLink
        ])
        vstack.axis = .vertical
        vstack.spacing = 16
        vstack.translatesAutoresizingMaskIntoConstraints = false

        // ריווחים לפי ה-XML
        // 32dp טופ לטייטל, 32dp בין טייטל לשדה אימייל, 16dp בין אימייל לסיסמה, 8dp ל-Forgot, 24dp ל-Login, 16dp ל-Register
        // נשתמש ב-setCustomSpacing כדי להתאים אחד-לאחד
        view.addSubview(vstack)
        NSLayoutConstraint.activate([
            vstack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            vstack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            vstack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
        ])
        vstack.setCustomSpacing(32, after: titleLabel)
        vstack.setCustomSpacing(16, after: emailField)
        vstack.setCustomSpacing(8,  after: passwordField)
        vstack.setCustomSpacing(24, after: forgotPassword)
        vstack.setCustomSpacing(16, after: loginButton)

        // יישור forgot לימין במסגרת ה-stack
        forgotPassword.contentHorizontalAlignment = .right
    }

    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Register"
        navigationItem.backButtonTitle = ""
        if let nav = navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            present(UINavigationController(rootViewController: vc), animated: true)
        }
    }

    @objc private func didTapForgot() {
        // TODO: נחבר למסך איפוס בהמשך
        print("Forgot tapped")
    }

    @objc private func didTapLogin() {
        print("Login tapped")
    }
}
