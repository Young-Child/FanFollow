//
//  LogOutViewController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/14.
//

import UIKit

import RxSwift

final class LogOutViewController: UIViewController {
    // View Properties
    private let transparentView = UIView().then {
        $0.backgroundColor = Constants.Color.grayDark
    }
    
    private let alertView = LogOutAlertView().then {
        $0.backgroundColor = Constants.Color.background
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    // Property
    weak var coordinator: LogOutCoordinator?
    private let viewModel: LogOutViewModel
    private let disposeBag = DisposeBag()
    private let dismissTap = UITapGestureRecognizer()
    
    // Initializer
    init(viewModel: LogOutViewModel) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        changeTransparency()
    }
}

// Binding
private extension LogOutViewController {
    func binding() {
        let input = bindingInput()
        
        bindingView()
        bindingOutPut(input)
    }
    
    func bindingView() {
        Observable.merge([
            dismissTap.rx.event.asObservable().map { _ in },
            alertView.didTapCancelButton.asObservable().map { _ in }
        ])
        .bind { _ in
            self.coordinator?.removeChild(to: self.coordinator)
            self.dismiss(animated: false)
        }
        .disposed(by: disposeBag)
    }
    
    func bindingOutPut(_ output: LogOutViewModel.Output) {
        output.logOutResult
            .asDriver(onErrorJustReturn: ())
            .drive { _ in
                self.coordinator?.reconnect(current: self)
            }
            .disposed(by: disposeBag)
    }
    
    func bindingInput() -> LogOutViewModel.Output {
        let logOutButtonTapped = alertView.didTapLogOutButton
            .map { _ in }.asObservable()
                
        let input = LogOutViewModel.Input(logOutButtonTapped: logOutButtonTapped)
        
        return viewModel.transform(input: input)
    }
}

// Configure UI
private extension LogOutViewController {
    func changeTransparency() {
        UIView.animate(withDuration: 0.1) {
            self.transparentView.alpha = 0.7
        }
    }
    
    func configureUI() {
        configureHierarchy()
        makeConstraints()
        transparentView.alpha = .zero
        
        transparentView.addGestureRecognizer(dismissTap)
        transparentView.isUserInteractionEnabled = true
    }

    func configureHierarchy() {
        [transparentView, alertView].forEach(view.addSubview(_:))
    }

    func makeConstraints() {
        transparentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view)
        }
        
        alertView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.6)
            $0.height.equalToSuperview().multipliedBy(0.2)
        }
    }
}
