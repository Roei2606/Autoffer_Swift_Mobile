import UIKit

final class FilledTextField: UITextField {

    enum Kind { case normal, password(showToggle: Bool) }

    private let padding = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    private let corner: CGFloat = 8
    private let kind: Kind
    private let border = CALayer()

    init(placeholder: String, kind: Kind = .normal) {
        self.kind = kind
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        self.placeholder = placeholder
        backgroundColor = AppColors.filledBox
        textColor = AppColors.white
        font = AppFont.body()
        borderStyle = .none
        layer.cornerRadius = corner
        layer.masksToBounds = true

        // מסגרת דקה בצבע hint (#D0D0D0)
        border.borderColor = AppColors.hint.withAlphaComponent(0.7).cgColor
        border.borderWidth = 1
        layer.addSublayer(border)

        heightAnchor.constraint(equalToConstant: 52).isActive = true

        switch kind {
        case .normal:
            break
        case .password(let showToggle):
            isSecureTextEntry = true
            if showToggle {
                let eye = UIButton(type: .system)
                eye.setImage(UIImage(systemName: "eye"), for: .normal)
                eye.tintColor = AppColors.white
                eye.addTarget(self, action: #selector(toggleSecure), for: .touchUpInside)
                rightView = eye
                rightViewMode = .always
            }
        }

        // placeholder בצבע hint
        attributedPlaceholder = NSAttributedString(string: placeholder,
            attributes: [.foregroundColor: AppColors.hint])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSubviews() {
        super.layoutSubviews()
        border.frame = bounds
        border.cornerRadius = layer.cornerRadius
    }

    // padding
    override func textRect(forBounds bounds: CGRect) -> CGRect { bounds.inset(by: padded(bounds)) }
    override func editingRect(forBounds bounds: CGRect) -> CGRect { bounds.inset(by: padded(bounds)) }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect { bounds.inset(by: padded(bounds)) }

    private func padded(_ bounds: CGRect) -> UIEdgeInsets {
        // אם יש כפתור עין, נשאיר קצת מקום מימין
        if rightView != nil { return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 40) }
        return padding
    }

    @objc private func toggleSecure() {
        isSecureTextEntry.toggle()
        if let btn = rightView as? UIButton {
            let name = isSecureTextEntry ? "eye" : "eye.slash"
            btn.setImage(UIImage(systemName: name), for: .normal)
        }
        // תיקון קפיצה של טקסט כשמשנים secure
        let tmp = text; text = nil; text = tmp
    }
}
