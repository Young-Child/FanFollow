//
//  UploadBottomSheetViewController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/01.
//

import UIKit

final class UploadBottomSheetViewController: UIViewController {
    // View Properties
    private let transparentView = UIView().then {
        $0.backgroundColor = Constants.Color.grayDark
    }
    
    private let bottomSheetView = UploadBottomSheetView(frame: .zero).then {
        $0.backgroundColor = Constants.Color.background
        $0.layer.cornerRadius = 10
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }
        
    // Property
    weak var coordinator: UploadCoordinator?
    
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

// Button Delegate Method
extension UploadBottomSheetViewController: UploadSheetButtonDelegate {
    func photoButtonTapped() {
        self.coordinator?.presentPostViewController(type: .photo)
        
        hideBottomSheet(completion: nil)
    }
    
    func linkButtonTapped() {
        self.coordinator?.presentPostViewController(type: .link)
        hideBottomSheet(completion: nil)
    }
    
    @objc func cancelButtonTapped() {
        hideBottomSheet {
            self.coordinator?.removeChild(to: self.coordinator)
        }
    }
    
    func hideBottomSheet(completion: (() -> Void)?) {
        self.bottomSheetView.snp.updateConstraints {
            $0.height.equalTo(0)
        }
        
        UIView.animate(withDuration: 0.25) {
            self.transparentView.alpha = .zero
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.dismiss(animated: true) {
                completion?()
            }
        }
    }
    
    func showBottomSheet() {
        let heightConstraint: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height * 0.3
        
        bottomSheetView.snp.remakeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.height.equalTo(heightConstraint)
        }
        
        UIView.animate(withDuration: 0.25) {
            self.transparentView.alpha = 0.7
            self.view.layoutIfNeeded()
        }
    }
}

// Configure UI
private extension UploadBottomSheetViewController {
    func configureUI() {
        bottomSheetView.buttonDelegate = self
        
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
