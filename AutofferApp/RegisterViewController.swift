import UIKit

final class RegisterViewController: UIViewController {

    // MARK: - UI

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Create Account"
        l.textColor = AppColors.white
        l.font = AppFont.title() // 28, bold
        return l
    }()

    private let firstNameField = FilledTextField(placeholder: "First Name")
    private let lastNameField  = FilledTextField(placeholder: "Last Name")
    private let emailField: FilledTextField = {
        let f = FilledTextField(placeholder: "Email")
        f.keyboardType = .emailAddress
        f.textContentType = .emailAddress
        return f
    }()
    private let passwordField = FilledTextField(placeholder: "Password", kind: .password(showToggle: true))
    private let confirmPasswordField = FilledTextField(placeholder: "Confirm Password", kind: .password(showToggle: true))
    private let phoneField: FilledTextField = {
        let f = FilledTextField(placeholder: "Phone Number")
        f.keyboardType = .phonePad
        f.textContentType = .telephoneNumber
        return f
    }()
    private let addressField = FilledTextField(placeholder: "Address")

    // Toggle group (Private / Architect) — כמו MaterialButtonToggleGroup
    private let toggleContainer = UIStackView()
    private let privateBtn: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Private", for: .normal)
        b.titleLabel?.font = AppFont.body()
        b.setTitleColor(AppColors.white, for: .normal)
        b.backgroundColor = AppColors.toggleUnselected
        b.layer.cornerRadius = 8
        b.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return b
    }()
    private let architectBtn: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Architect", for: .normal)
        b.titleLabel?.font = AppFont.body()
        b.setTitleColor(AppColors.white, for: .normal)
        b.backgroundColor = AppColors.toggleUnselected
        b.layer.cornerRadius = 8
        b.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return b
    }()

    private let registerButton = PrimaryWhiteButton(title: "Register")

    private let loginRedirect: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Already have an account? Login", for: .normal)
        b.setTitleColor(AppColors.hint, for: .normal)
        b.titleLabel?.font = UIFont.italicSystemFont(ofSize: 14) // 14sp italic
        return b
    }()

    // MARK: - State
    private enum ProfileType { case privateCustomer, architect }
    private var selectedProfile: ProfileType = .privateCustomer {
        didSet { updateToggleUI() }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.bg
        setupScroll()
        layoutForm()
        setupToggle()
        selectedProfile = .privateCustomer // ברירת מחדל כמו singleSelection
    }

    // MARK: - Setup

    private func setupScroll() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        // ScrollView ממלא מסך
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // contentView בתוך ה-Scroll — חשוב לקינפוג auto content size
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            // contentView תואם לרוחב המסך:
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }

    private func layoutForm() {
        // padding 24dp ל-ScrollView באנדרואיד → נוסיף margins ל-content
        contentView.layoutMargins = .init(top: 24, left: 24, bottom: 24, right: 24)

        // נשתמש ב-UIStackView אנכי כדי לשמור על מרווחים זהים ל-XML
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 12 // ברירת מחדל: 12dp בין רוב השדות

        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            stack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor)
        ])

        // Title — marginTop 32dp באנדרואיד
        let titleWrapper = UIView()
        titleWrapper.translatesAutoresizingMaskIntoConstraints = false
        titleWrapper.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: titleWrapper.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: titleWrapper.topAnchor, constant: 32),
            titleLabel.bottomAnchor.constraint(equalTo: titleWrapper.bottomAnchor)
        ])
        stack.addArrangedSubview(titleWrapper)

        // First Name — marginTop 24dp מול ה-Title באנדרואיד
        stack.setCustomSpacing(24, after: titleWrapper)
        stack.addArrangedSubview(firstNameField)

        // Last Name
        stack.addArrangedSubview(lastNameField)

        // Email
        stack.addArrangedSubview(emailField)

        // Password
        stack.addArrangedSubview(passwordField)

        // Confirm Password
        stack.addArrangedSubview(confirmPasswordField)

        // Phone
        stack.addArrangedSubview(phoneField)

        // Address
        stack.addArrangedSubview(addressField)

        // Toggle group (marginTop 16dp)
        stack.setCustomSpacing(16, after: addressField)
        toggleContainer.translatesAutoresizingMaskIntoConstraints = false
        toggleContainer.axis = .horizontal
        toggleContainer.spacing = 8
        toggleContainer.distribution = .fillEqually
        toggleContainer.addArrangedSubview(privateBtn)
        toggleContainer.addArrangedSubview(architectBtn)
        stack.addArrangedSubview(toggleContainer)

        // Register button (marginTop 24dp)
        stack.setCustomSpacing(24, after: toggleContainer)
        stack.addArrangedSubview(registerButton)

        // Already have account (marginTop 16dp, ממורכז)
        stack.setCustomSpacing(16, after: registerButton)
        let redirectWrapper = UIView()
        redirectWrapper.translatesAutoresizingMaskIntoConstraints = false
        redirectWrapper.addSubview(loginRedirect)
        loginRedirect.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginRedirect.centerXAnchor.constraint(equalTo: redirectWrapper.centerXAnchor),
            loginRedirect.topAnchor.constraint(equalTo: redirectWrapper.topAnchor),
            loginRedirect.bottomAnchor.constraint(equalTo: redirectWrapper.bottomAnchor)
        ])
        stack.addArrangedSubview(redirectWrapper)

        // קצת שטח בתחתית לגלילה נוחה
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.heightAnchor.constraint(equalToConstant: 24).isActive = true
        stack.addArrangedSubview(spacer)
    }

    private func setupToggle() {
        privateBtn.addTarget(self, action: #selector(didTapPrivate), for: .touchUpInside)
        architectBtn.addTarget(self, action: #selector(didTapArchitect), for: .touchUpInside)
    }

    private func updateToggleUI() {
        switch selectedProfile {
        case .privateCustomer:
            // נבחר: נשאיר כהה כמו באנדרואיד? ב-Material Toggle אין היילייט לבן בשורה ששלחת,
            // לכן נשמור רק טקסט לבן ורקע כהה בשניהם, אבל נסמן מסגרת דקה לפרטי.
            privateBtn.layer.borderWidth = 1
            privateBtn.layer.borderColor = AppColors.white.withAlphaComponent(0.6).cgColor

            architectBtn.layer.borderWidth = 0
            architectBtn.layer.borderColor = UIColor.clear.cgColor

        case .architect:
            architectBtn.layer.borderWidth = 1
            architectBtn.layer.borderColor = AppColors.white.withAlphaComponent(0.6).cgColor

            privateBtn.layer.borderWidth = 0
            privateBtn.layer.borderColor = UIColor.clear.cgColor
        }
    }

    // MARK: - Actions

    @objc private func didTapPrivate()   { selectedProfile = .privateCustomer }
    @objc private func didTapArchitect() { selectedProfile = .architect }
}

import SwiftUI

@available(iOS 13.0, *)
#Preview("Register Light") {
    UIViewControllerPreview { RegisterViewController() }
        .previewDevice(.init(rawValue: "iPhone 15"))
        .ignoresSafeArea()
}

@available(iOS 13.0, *)
#Preview("Register Dark RTL") {
    UIViewControllerPreview { RegisterViewController() }
        .preferredColorScheme(.dark)
        .environment(\.layoutDirection, .rightToLeft)
        .previewDevice(.init(rawValue: "iPhone 15 Pro Max"))
        .ignoresSafeArea()
}
