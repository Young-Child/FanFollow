//
//  ViewController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

/// 해당 파일은 예시 파일입니다. 삭제 하셔도 됩니다.

import UIKit
import RxSwift

final class ExampleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
    }
    
//    func binding() {
//        let input = ExampleViewModel.Input(
//            viewWillAppear: rx.methodInvoked(#selector(viewWillAppear)).map { _ in }.asObservable()
//        )
//        
//        let output = viewModel.transform(input: input)
//        
//        output.users
//            .bind(to: titleLabel.rx.text)
//            .dispose(by: disposeBag)
//    }
}
