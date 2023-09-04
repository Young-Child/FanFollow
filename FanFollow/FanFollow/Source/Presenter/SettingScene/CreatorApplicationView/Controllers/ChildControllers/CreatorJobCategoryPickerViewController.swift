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
    
    var selectedCategory: Observable<JobCategory> {
        return jobCategoryPickerView.rx.selectedCategory.asObservable()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(jobCategoryPickerView)
        jobCategoryPickerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        nextButtonEnable.accept(true)
    }
}
