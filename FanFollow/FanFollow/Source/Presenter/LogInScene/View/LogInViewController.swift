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
        $0.image = UIImage(named: "iconImage")
        $0.contentMode = .scaleAspectFill
    }
    
    private var appleLogInButton = UIButton().then {
        $0.layer.cornerRadius = 4
        $0.setImage(UIImage(named: "Apple"), for: .normal)
        $0.backgroundColor = .label
        $0.setTitle(Constants.appleButtonText, for: .normal)
    }
    
    // Properties
    weak var coordinator: LogInCoordinator?
    private var disposeBag = DisposeBag()
    
    // Initializer
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bind()
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
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return
        }
        
        let identityToken = appleIDCredential.identityToken
        
        // TODO: - ViewModel로 전달
        print("User IdentityToken : \(String(data: identityToken ?? Data(), encoding: .utf8))")
    }
}

// Bind Method
extension LogInViewController {
    func bind() {
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
        [logoImageView, appleLogInButton].forEach(view.addSubview(_:))
    }
    
    func makeConstraints() {
        logoImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(40)
            $0.trailing.equalToSuperview().offset(-40)
            $0.bottom.equalTo(view.snp.centerY).offset(-40)
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
    }
}
