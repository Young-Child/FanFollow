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
        $0.backgroundColor = .darkGray
    }
    
    private let alertView = LogOutAlertView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    // Property
    weak var coordinator: LogOutCoordinator?
    private let viewModel: LogOutViewModel
    private let disposeBag = DisposeBag()
    
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
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(cancelButtonTapped))
        transparentView.addGestureRecognizer(dismissTap)
        transparentView.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        changeTransparency()
    }
}

// Binding
extension LogOutViewController {
    func binding() {
        let input = bindingInput()
        
        bindingOutPut(input)
    }
    
    func bindingOutPut(_ output: LogOutViewModel.Output) {
        output.logOutResult
            .asDriver(onErrorJustReturn: ())
            .drive { _ in
                self.coordinator?.close(viewController: self)
            }
            .disposed(by: disposeBag)
    }
    
    func bindingInput() -> LogOutViewModel.Output {
        let logOutButtonTapped = rx.methodInvoked(#selector(logOutButtonTapped))
            .map { _ in }.asObservable()
        
        let input = LogOutViewModel.Input(logOutButtonTapped: logOutButtonTapped)
        
        return viewModel.transform(input: input)
    }
}

// ButtonDelegate
extension LogOutViewController: LogOutViewButtonDelegate {
    @objc func cancelButtonTapped() {
        self.coordinator?.close(viewController: self)
    }
    
    @objc func logOutButtonTapped() {
        // TODO: - Do Not Thing
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
        alertView.logOutViewButtonDelegate = self
        
        configureHierarchy()
        makeConstraints()
        transparentView.alpha = .zero
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
