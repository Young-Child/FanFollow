//
//  CreatorJobCategoryPickerViewController.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/03.
//

import UIKit
import RxSwift
import RxCocoa

final class CreatorJobCategoryPickerViewController: UIViewController {
    private let jobCategoryPickerView = JobCategoryPickerView()

    var updatedJobCategoryIndex: Observable<Int> {
        return jobCategoryPickerView.rx.itemSelected
            .map { row, _ in return row }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(jobCategoryPickerView)
        jobCategoryPickerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
    }
}
