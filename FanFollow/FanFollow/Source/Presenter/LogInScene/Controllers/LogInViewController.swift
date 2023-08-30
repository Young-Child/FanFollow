//
//  LogInViewController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/10.
//

import AuthenticationServices
import UIKit

import RxSwift
import RxCocoa

final class LogInViewController: UIViewController {
    // View Properties
    private let logoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = Constants.Image.logoImageMiddle
    }
    
    private let mainLabel = UILabel().then {
        $0.attributedText = Constants.Text.onboardingMainText
        $0.font = .coreDreamFont(ofSize: 32, weight: .bold)
        $0.textAlignment = .left
    }
    
    private let subLabel = UILabel().then {
        $0.font = .coreDreamFont(ofSize: 16, weight: .medium)
        $0.text = Constants.Text.onboardingSubText
        $0.textColor = .label
        $0.textAlignment = .left
        $0.adjustsFontSizeToFitWidth = true
    }
    
    private var appleLogInButton = UIButton().then {
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        $0.marginImageWithText(margin: 16)
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 4
        $0.setImage(Constants.Image.appleLogo, for: .normal)
        $0.backgroundColor = .label
        $0.setTitle(Constants.Text.appleLoginButtonText, for: .normal)
    }
    
    private var loginInformationLabel = UILabel.configureAuthInformationLabel()
    
    // Properties
    weak var coordinator: LogInCoordinator?
    private let viewModel: LogInViewModel
    private var disposeBag = DisposeBag()
    private let identityToken = PublishRelay<String>()
    
    // Initializer
    init(viewModel: LogInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        binding()
    }
}

// Apple LogIn
extension LogInViewController: ASAuthorizationControllerDelegate {
    func appleIDButtonTapped() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        guard let error = error as? ASAuthorizationError else { return }
        
        if error.code == .canceled { return }
        
        let controller = UIAlertController(
            title: Constants.Text.loginAlertTitle,
            message: Constants.Text.loginAlertMessage,
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(title: Constants.Text.confirm, style: .default)
        controller.addAction(confirmAction)
        self.present(controller, animated: true)
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityTokenData = appleIDCredential.identityToken,
              let token = String(data: identityTokenData, encoding: .utf8) else {
            return
        }
        
        identityToken.accept(token)
    }
}

// Apple Login View Method
extension LogInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = self.view.window else { return UIWindow() }
        return window
    }
}

// Bind Method
extension LogInViewController {
    func binding() {
        let output = bindingInput()
        
        output.logInSuccess
            .asDriver(onErrorJustReturn: false)
            .filter { $0 }
            .drive(onNext: { _ in self.coordinator?.didSuccessLogin() })
            .disposed(by: disposeBag)
        
        buttonBinding()
    }
    
    func bindingInput() -> LogInViewModel.Output {
        let input = LogInViewModel.Input(logInButtonTapped: identityToken.asObservable())
        
        return viewModel.transform(input: input)
    }
    
    private func buttonBinding() {
        appleLogInButton.rx.tap
            .bind {
                self.appleIDButtonTapped()
            }
            .disposed(by: disposeBag)
    }
}

private extension LogInViewController {
    func configureAuthInformationActions() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapPresentLink)
        )
        
        loginInformationLabel.isUserInteractionEnabled = true
        loginInformationLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapPresentLink(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: loginInformationLabel)
        let agree = Constants.Text.agreementName
        let privacy = Constants.Text.privacyName
        
        if let agreeRect = loginInformationLabel.boundingRectForCharacterRange(subText: agree),
           agreeRect.contains(point) {
            coordinator?.presentLink(to: Constants.Text.agreementInformationURL)
        }
        
        if let privacyRect = loginInformationLabel.boundingRectForCharacterRange(subText: privacy),
           privacyRect.contains(point) {
            coordinator?.presentLink(to: Constants.Text.privacyInformationURL)
        }
    }
}

// Configure UI
private extension LogInViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        configureHierarchy()
        makeConstraints()
        configureAuthInformationActions()
    }
    
    func configureHierarchy() {
        [
            logoImageView,
            mainLabel,
            subLabel,
            appleLogInButton,
            loginInformationLabel
        ].forEach(view.addSubview(_:))
    }
    
    func makeConstraints() {
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            $0.leading.equalToSuperview().offset(Constants.Spacing.medium)
            $0.height.equalTo(80)
            $0.width.equalTo(160)
        }
        
        mainLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(Constants.Spacing.medium)
            $0.leading.equalTo(logoImageView)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(Constants.Spacing.small)
            $0.leading.trailing.equalTo(mainLabel)
        }
        
        appleLogInButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.bottom.equalTo(loginInformationLabel.snp.top).offset(-Constants.Spacing.large)
            $0.leading.trailing.equalToSuperview().inset(Constants.Spacing.medium)
        }
        
        loginInformationLabel.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.7)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-Constants.Spacing.large)
        }
    }
}
