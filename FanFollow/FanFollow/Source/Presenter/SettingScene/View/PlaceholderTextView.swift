//
//  PlaceholderTextView.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/02.
//

import UIKit

final class PlaceholderTextView: UITextView {
    private let placeholderLabel = UILabel().then { label in
        label.textColor = Constants.Color.gray
        label.font = .coreDreamFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.isHidden = false
    }

    var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }

    var placeholderColor: UIColor = Constants.Color.gray {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }

    var placeholderFont: UIFont? = .coreDreamFont(ofSize: 14, weight: .regular) {
        didSet {
            placeholderLabel.font = placeholderFont
        }
    }

    var maxNumberOfLines: Int = 5

    override var text: String? {
        didSet {
            placeholderLabel.isHidden = text?.isEmpty == false
        }
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PlaceholderTextView {
    func configureUI() {
        configureHierarchy()
        configureConstraints()
        configureObserver()
    }

    func configureHierarchy() {
        addSubview(placeholderLabel)
    }

    func configureConstraints() {
        placeholderLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
    }

    func configureObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: UITextView.textDidChangeNotification,
            object: nil
        )
    }

    @objc
    func textDidChange() {
        placeholderLabel.isHidden = text?.isEmpty == false
        guard let lineHeight = font?.lineHeight else { return }
        let numberOfLines = Int(contentSize.height / lineHeight)
        if numberOfLines > maxNumberOfLines {
            self.deleteBackward()
        }
    }
}
