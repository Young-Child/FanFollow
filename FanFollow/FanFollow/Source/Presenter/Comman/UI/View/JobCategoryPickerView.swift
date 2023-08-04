//
//  JobCategoryPickerView.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

class JobCategoryPickerView: UIPickerView {
    private let categories = JobCategory.allCases.dropLast(1)
    
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
