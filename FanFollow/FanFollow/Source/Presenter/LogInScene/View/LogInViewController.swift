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
        $0.image = UIImage(named: "mainLogo")
    }
    
    private let mainLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 32, weight: .bold)
        $0.text = Constants.mainText
        $0.textColor = .label
        $0.textAlignment = .left
        $0.adjustsFontSizeToFitWidth = true
    }
    
    private let subLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.text = Constants.subText
        $0.textColor = .label
        $0.textAlignment = .left
        $0.adjustsFontSizeToFitWidth = true
    }
    
    private var appleLogInButton = UIButton().then {
        $0.layer.cornerRadius = 4
        $0.setImage(UIImage(named: "Apple"), for: .normal)
        $0.backgroundColor = .label
        $0.setTitle(Constants.appleButtonText, for: .normal)
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
        [logoImageView, mainLabel, subLabel, appleLogInButton].forEach(view.addSubview(_:))
    }
    
    func makeConstraints() {
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(90)
            $0.leading.equalToSuperview().offset(25)
            $0.height.equalTo(80)
        }
        
        mainLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(45)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(45)
        }
        
        appleLogInButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().offset(-150)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
}

private extension LogInViewController {
    enum Constants {
        static let appleButtonText = "Apple로 계속하기"
        static let mainText = "모든 직군의 이야기"
        static let subText = "나와 같은 사람들의 생각, 기록, 네트워킹"
    }
}