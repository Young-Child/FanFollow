//
//  ProfileImagePickerViewController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import RxSwift
import Kingfisher

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

extension ProfileImagePickerViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? AssetImageGridCell
        cell?.setSelected(to: true)
        
        let image = cell?.getImage()
        self.selectedImage = image
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
