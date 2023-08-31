//
//  BlockCreatorCell.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/31.
//

import UIKit

final class BlockCreatorCell: UITableViewCell {
    // View Properties
    private let profileImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 30
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = Constants.Color.gray
    }

    private let nickNameLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.textColor = Constants.Color.blue
        $0.font = .coreDreamFont(ofSize: 17, weight: .extraBold)
    }

    private let jobLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.textColor = Constants.Color.blue
        $0.font = .coreDreamFont(ofSize: 14, weight: .regular)
    }

    private let labelStackView = UIStackView().then { stackView in
        stackView.spacing = Constants.Spacing.xSmall
        stackView.axis = .vertical
    }

    private let stackView = UIStackView().then { stackView in
        stackView.spacing = Constants.Spacing.small
        stackView.alignment = .center
    }

    private let blockToggleButton = UIButton(type: .roundedRect).then { button in
        let resolveTitle = Constants.Text.blockToggleButtonResolveTitle
        let blockTitle = Constants.Text.blockToggleButtonBlockTitle

        button.layer.cornerRadius = 4
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.titleLabel?.font = .coreDreamFont(ofSize: 12, weight: .light)
        button.backgroundColor = Constants.Color.blue
        button.setTitleColor(Constants.Color.background, for: .normal)
        button.setTitleColor(Constants.Color.background, for: .selected)
        button.setTitle(resolveTitle, for: .normal)
        button.setTitle(blockTitle, for: .selected)
    }

    // Properties
    private weak var delegate: BlockCreatorCellDelegate?
    private var blockCreator: BlockCreator?

    // Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        blockCreator = nil
        profileImageView.image = UIImage(named: "defaultProfile")
        nickNameLabel.text = nil
        jobLabel.text = nil
        blockToggleButton.isSelected = false
    }
}

// Setting UI Data

extension BlockCreatorCell {
    func configure(
        with blockCreator: BlockCreator,
        delegate: BlockCreatorCellDelegate? = nil
    ) {
        self.blockCreator = blockCreator
        self.delegate = delegate

        let creator = blockCreator.creator
        profileImageView.setImageProfileImage(to: creator.profileURL, for: creator.id)
        nickNameLabel.text = creator.nickName
        if let jobCategory = creator.jobCategory {
            jobLabel.attributedText = attributedJobString(jobCategory)
        }
        blockToggleButton.isSelected = !blockCreator.isBlock
    }

    private func attributedJobString(_ jobCategory: JobCategory) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(
            string: Constants.Text.jobCategory + " ",
            attributes: [.foregroundColor: Constants.Color.grayDark]
        )
        attributedString.append(
            NSAttributedString(
                string: jobCategory.categoryName,
                attributes: [.foregroundColor: Constants.Color.blue]
            )
        )
        return attributedString
    }
}

// Configure UI
private extension BlockCreatorCell {
    func configureUI() {
        configureHierarchy()
        configureConstraints()
        configureBlockToggleButtonAction()
    }

    func configureHierarchy() {
        [nickNameLabel, jobLabel].forEach(labelStackView.addArrangedSubview)
        [profileImageView, labelStackView, blockToggleButton].forEach(stackView.addArrangedSubview)
        contentView.addSubview(stackView)
    }

    func configureConstraints() {
        jobLabel.setContentHuggingPriority(.required, for: .vertical)
        blockToggleButton.setContentHuggingPriority(.required, for: .horizontal)

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Constants.Spacing.small)
        }

        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(60)
        }
    }

    func configureBlockToggleButtonAction() {
        blockToggleButton.addAction(UIAction { [weak self] _ in
            guard let self,
                  let banID = self.blockCreator?.creator.id else { return }
            self.delegate?.blockCreatorCell(didTapBlockToggleButton: banID)
        }, for: .touchUpInside)
    }
}

protocol BlockCreatorCellDelegate: AnyObject {
    func blockCreatorCell(didTapBlockToggleButton banID: String)
}
