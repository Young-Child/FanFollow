//
//  UploadPhotoViewController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/01.
//

import UIKit
import RxSwift

final class UploadPhotoViewController: UIViewController {
    // View Properties
    private let titleTextField = UITextField().then {
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.placeholder = Constants.content
    }
    
    private let contentsTextView = UITextView().then {
        $0.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

private extension UploadPhotoViewController {
    enum Constants {
        static let title = "제목을 작성해보세요."
        static let content = "글을 작성해보세요."
    }
}
