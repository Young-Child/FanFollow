//
//  CreatorApplicationChildController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import RxSwift
import RxRelay

class CreatorApplicationChildController: UIViewController {
    private(set) var nextButtonEnable = BehaviorRelay(value: false)
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureKeyboardDismissAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentValue = nextButtonEnable.value
        nextButtonEnable.accept(currentValue)
    }
    
    private func configureKeyboardDismissAction() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapKeyboardDismiss)
        )
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapKeyboardDismiss() {
        view.endEditing(true)
    }
}
