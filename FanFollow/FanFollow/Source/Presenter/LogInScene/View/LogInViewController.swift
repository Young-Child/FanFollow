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
        $0.attributedText = ConstantsLogin.mainText
        $0.font = .coreDreamFont(ofSize: 32, weight: .bold)
        $0.textAlignment = .left
    }
    
    private let subLabel = UILabel().then {
        $0.font = .coreDreamFont(ofSize: 16, weight: .medium)
        $0.text = ConstantsLogin.subText
        $0.textColor = .label
        $0.textAlignment = .left
        $0.adjustsFontSizeToFitWidth = true
    }
    
    private var appleLogInButton = UIButton().then {
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        $0.marginImageWithText(margin: 16)
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 4
        $0.setImage(UIImage(named: "Apple"), for: .normal)
        $0.backgroundColor = .label
        $0.setTitle(ConstantsLogin.appleButtonText, for: .normal)
    }
    
    private var loginInformationLabel = UILabel().then {
        $0.textAlignment = .center
        $0.text = ConstantsLogin.information
        $0.font = .systemFont(ofSize: 14, weight: .light)
        $0.textColor = .systemGray4
    }
    
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
extension LogInViewController: ASAuthorizationControllerDelegate,
                                ASAuthorizationControllerPresentationContextProviding {
    func appleIDButtonTapped() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
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

// Bind Method
extension LogInViewController {
    func binding() {
        let output = bindingInput()
        
        // TODO: - 추후 로직 추가 필요
        output.logInSuccess
            .subscribe()
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

// Configure UI
private extension LogInViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        configureHierarchy()
        makeConstraints()
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
            $0.leading.equalToSuperview().offset(18)
            $0.height.equalTo(80)
            $0.width.equalTo(160)
        }
        
        mainLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(30)
            $0.leading.equalTo(logoImageView)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(mainLabel)
        }
        
        appleLogInButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.bottom.equalTo(loginInformationLabel.snp.top).offset(-16)
            $0.leading.trailing.equalToSuperview().inset(18)
        }
        
        loginInformationLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().offset(-48)
        }
    }
}

private extension LogInViewController {
    enum ConstantsLogin {
        static let appleButtonText = "Apple로 계속하기"
        static let mainText = NSMutableAttributedString()
            .regular("모든 ")
            .highlight("직군", to: Constants.Color.blue)
            .regular("의 이야기")
        static let subText = "나와 같은 사람들의 생각, 기록, 네트워킹"
        static let information = "추후 더 많은 로그인 기능을 제공할 예정입니다."
    }
}

extension NSMutableAttributedString {
    func regular(_ value: String) -> NSMutableAttributedString {
        self.append(NSAttributedString(string: value))
        return self
    }
    
    func highlight(_ value: String, to color: UIColor?) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color as Any
        ]
        
        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }
}
