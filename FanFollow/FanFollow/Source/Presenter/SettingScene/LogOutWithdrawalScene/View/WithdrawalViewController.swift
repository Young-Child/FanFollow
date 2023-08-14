//
//  WithdrawalViewController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/14.
//

import UIKit

final class WithdrawalViewController: UIViewController {
    // View Properties
    private let transparentView = UIView().then {
        $0.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
    }
    
    private let bottomSheetView = WithdrawalBottomSheetView(frame: .zero).then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }
    
    // Property
    weak var coordinator: WithdrawalCoordinator?
    
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
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(cancelButtonTapped))
        transparentView.addGestureRecognizer(dismissTap)
        transparentView.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showBottomSheet()
    }
}

extension WithdrawalViewController {
    @objc func cancelButtonTapped() {
        bottomSheetView.snp.updateConstraints {
            $0.top.equalToSuperview().offset(self.view.safeAreaLayoutGuide.layoutFrame.height)
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.transparentView.alpha = .zero
            self.view.layoutIfNeeded()
        }) { _ in
            self.coordinator?.close(viewController: self)
        }
    }
    
    func showBottomSheet() {
        let topConstant: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height * 0.7
        
        bottomSheetView.snp.remakeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(topConstant)
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
            $0.top.leading.trailing.bottom.equalTo(view)
        }
        
        bottomSheetView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
        }
    }
}
