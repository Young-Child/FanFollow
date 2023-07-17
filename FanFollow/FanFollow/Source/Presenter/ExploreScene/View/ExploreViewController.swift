//
//  ExploreViewController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/17.
//

import UIKit
import RxSwift

final class ExploreViewController: UIViewController {
    // Properties
    private let viewModel: ExploreViewModel
    private let disposeBag = DisposeBag()
    
    // Initializer
    init(viewModel: ExploreViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
