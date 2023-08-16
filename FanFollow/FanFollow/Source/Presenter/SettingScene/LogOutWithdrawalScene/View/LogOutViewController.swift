//
//  LogOutViewController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/14.
//

import UIKit

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        changeTransparency()
    }
}

extension LogOutViewController {
    @objc func cancelButtonTapped() {
        self.coordinator?.close(viewController: self)
    }
    
    func changeTransparency() {
        UIView.animate(withDuration: 0.1) {
            self.transparentView.alpha = 0.7
        }
    }
}

// Configure UI
private extension LogOutViewController {
    func configureUI() {
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
