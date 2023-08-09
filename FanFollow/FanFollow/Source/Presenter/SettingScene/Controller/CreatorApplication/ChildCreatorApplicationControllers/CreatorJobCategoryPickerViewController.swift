//
//  CreatorJobCategoryPickerViewController.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/03.
//

import UIKit

import RxCocoa
import RxSwift

final class CreatorJobCategoryPickerViewController: CreatorApplicationChildController {
    private let jobCategoryPickerView = JobCategoryPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(jobCategoryPickerView)
        jobCategoryPickerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        bind()
    }
    
    func bind() {
        jobCategoryPickerView.rx.itemSelected
            .map { $0.row == .zero }
            .bind(to: nextButtonEnable)
            .disposed(by: disposeBag)
    }
}
