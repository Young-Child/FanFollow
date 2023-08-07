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
        $0.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
    }
    
    private let bottomSheetView = UploadBottomSheetView(
        frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 100, height: 100))
    ).then {
        $0.backgroundColor = .white
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
    }
}

// Button Delegate Method
extension UploadBottomSheetViewController: SheetButtonDelegate {
    func photoButtonTapped() {
        coordinator?.presentPostViewController(type: .photo, viewController: self)
    }
    
    func linkButtonTapped() {
        coordinator?.presentPostViewController(type: .link, viewController: self)
    }
    
    func cancelButtonTapped() {
        coordinator?.close(viewController: self)
    }
}

// Configure UI
private extension UploadBottomSheetViewController {
    func configureUI() {
        bottomSheetView.buttonDelegate = self
        
        configureHierarchy()
        makeConstraints()
    }

    func configureHierarchy() {
        [transparentView, bottomSheetView].forEach(view.addSubview(_:))
    }

    func makeConstraints() {
        transparentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view)
        }
        
        let topConstant: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height * 2 / 3
        
        bottomSheetView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(topConstant)
        }
    }
}
