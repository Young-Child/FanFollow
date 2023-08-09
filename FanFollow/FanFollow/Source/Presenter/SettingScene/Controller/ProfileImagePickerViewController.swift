//
//  ProfileImagePickerViewController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import Kingfisher
import RxSwift

final class ProfileImagePickerViewController: ImagePickerViewController {
    private var disposeBag = DisposeBag()
    private let profileImagePickerViewModel: ProfileImagePickerViewModel
    
    init(viewModel: ProfileImagePickerViewModel) {
        self.profileImagePickerViewModel = viewModel
        super.init(title: Constants.title)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        binding()
    }
}

private extension ProfileImagePickerViewController {
    func binding() {
        let input = ProfileImagePickerViewModel.Input(
            updateImage: configureUpdateEvent()
        )
        
        let output = profileImagePickerViewModel.transform(input: input)
        
        bindingOutput(to: output)
    }
    
    func bindingOutput(to output: ProfileImagePickerViewModel.Output) {
        output.imageUploadResult
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: setKFCache)
            .disposed(by: disposeBag)
    }
    
    func configureUpdateEvent() -> Observable<Data?> {
        guard let rightButton = navigationItem.rightBarButtonItem else { return .empty() }
        return rightButton.rx.tap
            .map { _ in return self.selectedImage?.pngData() }
    }
    
    func setKFCache(to userID: String) {
        guard let selectedImage = selectedImage else { return }
        let key = "profile_\(userID)"
        ImageCache.default.changeMemoryImage(to: selectedImage, key: key)
        
        self.dismiss(animated: true)
    }
}

private extension ProfileImagePickerViewController {
    enum Constants {
        static let title = "프로필 이미지 선택"
    }
}
