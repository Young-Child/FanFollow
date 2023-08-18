//
//  WithdrawalViewController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/14.
//

import UIKit

import RxSwift

final class WithdrawalViewController: UIViewController {
    // View Properties
    private let transparentView = UIView().then {
        $0.backgroundColor = .darkGray
    }
    
    private let bottomSheetView = WithdrawalBottomSheetView(frame: .zero).then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }
    
    // Property
    weak var coordinator: WithdrawalCoordinator?
    private let viewModel: WithdrawlViewModel
    private let disposeBag = DisposeBag()
    
    // Initializer
    init(viewModel: WithdrawlViewModel) {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showBottomSheet()
    }
}

// Binding
extension WithdrawalViewController {
    func binding() {
        let input = bindingInput()
        
        bindingOutPut(input)
    }
    
    func bindingOutPut(_ output: WithdrawlViewModel.Output) {
        output.withdrawlResult
            .asDriver(onErrorJustReturn: ())
            .drive { _ in
                self.coordinator?.reconnect(current: self)
            }
            .disposed(by: disposeBag)
    }
    
    func bindingInput() -> WithdrawlViewModel.Output {
        let withdrawalButtonTapped = bottomSheetView.didTapWithdrawalButton
            .asObservable()
        
        let input = WithdrawlViewModel.Input(withdrawlButtonTapped: withdrawalButtonTapped)
        
        return viewModel.transform(input: input)
    }
}

extension WithdrawalViewController {
    @objc func cancelButtonTapped() {
        bottomSheetView.snp.updateConstraints {
            $0.height.equalTo(0)
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.transparentView.alpha = .zero
            self.view.layoutIfNeeded()
        }) { _ in
            self.dismiss(animated: true) {
                self.coordinator?.removeChild(to: self.coordinator)
            }
        }
    }
    
    func showBottomSheet() {
        let heightConstraint: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height * 0.4
        
        bottomSheetView.snp.remakeConstraints {
            $0.height.equalTo(heightConstraint)
            $0.leading.bottom.trailing.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.25) {
            self.transparentView.alpha = 0.7
            self.view.layoutIfNeeded()
        }
    }
}

// Configure UI
private extension WithdrawalViewController {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
        transparentView.alpha = .zero
    }

    func configureHierarchy() {
        [transparentView, bottomSheetView].forEach(view.addSubview(_:))
    }

    func makeConstraints() {
        transparentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottomSheetView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
        }
    }
}
