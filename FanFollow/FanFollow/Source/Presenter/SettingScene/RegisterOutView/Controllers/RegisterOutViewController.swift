//
//  RegisterOutViewController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/14.
//

import UIKit

import RxCocoa
import RxSwift

final class RegisterOutViewController: UIViewController {
    // View Properties
    private let titleLabel = UILabel().then {
        $0.text = Constants.Text.withdrawalTitle
        $0.font = .coreDreamFont(ofSize: 16, weight: .regular)
        $0.textColor = Constants.Color.label
    }
    
    private let noticeLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = Constants.Text.withdrawalNotice
        $0.font = .coreDreamFont(ofSize: 16, weight: .regular)
        $0.textColor = Constants.Color.label
    }
    
    private let agreeCheckButton = UIButton().then {
        $0.tintColor = Constants.Color.blue
        $0.setImage(Constants.Image.checkMark, for: .selected)
        $0.setImage(Constants.Image.square, for: .normal)
    }
    
    private let agreeLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = Constants.Color.gray
        $0.text = Constants.Text.withdrawalAgree
        $0.font = .coreDreamFont(ofSize: 14, weight: .regular)
    }
    
    private let agreeStackView = UIStackView().then {
        $0.spacing = 8
        $0.alignment = .fill
        $0.axis = .horizontal
        $0.distribution = .fill
    }
    
    private let registerOutButton = UIButton().then {
        $0.isEnabled = false
        $0.layer.cornerRadius = 4
        $0.setTitle(Constants.Text.withdrawal, for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = Constants.Color.gray
    }
    
    // Property
    weak var coordinator: WithdrawalCoordinator?
    private let viewModel: RegisterOutViewModel
    private let disposeBag = DisposeBag()
    
    // Initializer
    init(viewModel: RegisterOutViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        binding()
    }
}

// Binding
extension RegisterOutViewController {
    func binding() {
        let input = bindingInput()
        
        bindingOutPut(input)
    }
    
    func bindingOutPut(_ output: RegisterOutViewModel.Output) {
        output.withdrawlResult
            .asDriver(onErrorJustReturn: ())
            .drive { _ in
                self.coordinator?.reconnect(current: self)
            }
            .disposed(by: disposeBag)
    }
    
    func bindingInput() -> RegisterOutViewModel.Output {
        let registerOutButtonTapped = registerOutButton.rx.tap
            .asObservable()
        
        let input = RegisterOutViewModel.Input(withdrawlButtonTapped: registerOutButtonTapped)
        
        return viewModel.transform(input: input)
    }
}

// Configure UI
private extension RegisterOutViewController {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [agreeCheckButton, agreeLabel].forEach(agreeStackView.addArrangedSubview(_:))
        [titleLabel, noticeLabel, agreeStackView, registerOutButton].forEach(view.addSubview(_:))
    }
    
    func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(Constants.Spacing.medium)
            $0.trailing.equalToSuperview().offset(-Constants.Spacing.medium)
        }
        
        noticeLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.Spacing.medium)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        agreeStackView.snp.makeConstraints {
            $0.top.equalTo(noticeLabel.snp.bottom).offset(Constants.Spacing.medium)
            $0.leading.trailing.equalTo(noticeLabel)
        }
        
        registerOutButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(agreeStackView.snp.bottom).offset(Constants.Spacing.medium)
            $0.leading.trailing.equalTo(agreeStackView)
            $0.bottom.equalToSuperview().offset(-Constants.Spacing.large)
        }
    }
}
