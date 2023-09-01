//
//  BottomSheetViewController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import RxSwift

final class BottomSheetViewController: UIViewController {
    // View Properties
    private let transparentView = UIView().then {
        $0.backgroundColor = .darkGray.withAlphaComponent(0.7)
    }
    
    private let bottomContainerView = UIView().then {
        $0.backgroundColor = .systemBackground
        $0.layer.cornerRadius = 8
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }
    
    private let childController: UIViewController
    
    // Property
    private let bottomHeightRatio: Double
    
    // Initializer
    init(controller: UIViewController, bottomHeightRatio: Double) {
        self.childController = controller
        self.bottomHeightRatio = bottomHeightRatio
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(didTapDismiss))
        transparentView.addGestureRecognizer(dismissTap)
        transparentView.isUserInteractionEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        showBottomSheet()
    }
    
    @objc private func didTapDismiss() {
        // TODO: - Coordinator로 dismiss
        self.dismiss(animated: true)
    }
}

extension BottomSheetViewController {
    func showBottomSheet() {
        let height = view.frame.height * bottomHeightRatio
        bottomContainerView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
        
        UIView.animate(withDuration: 0.1) {
            self.transparentView.alpha = 0.4
            self.view.layoutIfNeeded()
        }
    }
}

private extension BottomSheetViewController {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
        self.transparentView.alpha = .zero
    }
    
    func configureHierarchy() {
        addChild(childController)
        bottomContainerView.addSubview(childController.view)
        
        view.addSubview(transparentView)
        view.addSubview(bottomContainerView)
    }
    
    func makeConstraints() {
        transparentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottomContainerView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.height.equalTo(0)
        }
        
        childController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
