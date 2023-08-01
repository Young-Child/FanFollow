//
//  PostBottomSheetViewController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/01.
//

import UIKit

final class PostBottomSheetViewController: UIViewController {
    // View Properties
    private let transparentView = UIView().then {
        $0.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
    }
    
    // Property
    weak var coordinator: SettingCoordinator?
    
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

// Configure UI
private extension PostBottomSheetViewController {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }

    func configureHierarchy() {
        view.addSubview(transparentView)
    }

    func makeConstraints() {
        transparentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view)
        }
    }
}
