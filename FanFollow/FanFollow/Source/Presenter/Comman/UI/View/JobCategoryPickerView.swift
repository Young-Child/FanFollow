//
//  JobCategoryPickerView.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import RxSwift
import RxCocoa

extension Reactive where Base: JobCategoryPickerView {
    var selectedCategory: ControlEvent<JobCategory> {
        let source = base.rx.itemSelected.map(\.row)
            .filter { $0 == .zero }
            .compactMap { base.categories[safe: $0] }
        return ControlEvent(events: source)
    }
}

class JobCategoryPickerView: UIPickerView {
    let categories = JobCategory.allCases
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension JobCategoryPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
}

extension JobCategoryPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].categoryName
    }
}
