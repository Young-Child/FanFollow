//
//  UploadImagePickerViewController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/02.
//

import UIKit
import RxSwift

final class UploadImagePickerViewController: ImagePickerViewController {
    private var disposeBag = DisposeBag()
    
    init() {
        super.init(title: Constants.title)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

private extension UploadImagePickerViewController {
    enum Constants {
        static let title = "게시물 이미지 선택"
    }
}
