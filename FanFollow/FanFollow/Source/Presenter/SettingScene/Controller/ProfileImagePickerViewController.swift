//
//  ProfileImagePickerViewController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import RxSwift
import Kingfisher

final class ProfileImagePickerViewController: PhotoAssetGridViewController {
    private var maxImageCount: Int
    private var selectedImage: UIImage?
    private var disposeBag = DisposeBag()
    private let profileImagePickerViewModel: ProfileImagePickerViewModel
    
    init(viewModel: ProfileImagePickerViewModel, maxImageCount: Int = 1) {
        self.profileImagePickerViewModel = viewModel
        self.maxImageCount = maxImageCount
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        binding()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? AssetImageGridCell
        cell?.setSelected(to: true)
        
        let image = cell?.getImage()
        self.selectedImage = image
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? AssetImageGridCell
        cell?.setSelected(to: false)
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
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.removeCacheKF(to: $0)
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func configureUpdateEvent() -> Observable<Data?> {
        guard let rightButton = navigationItem.rightBarButtonItem else { return .empty() }
        
        return rightButton.rx.tap
            .map { _ in return self.selectedImage?.pngData() }
    }
    
    func removeCacheKF(to url: String) {
        if ImageCache.default.isCached(forKey: url) {
            ImageCache.default.removeImage(forKey: url)
        }
    }
}

private extension ProfileImagePickerViewController {
    func configureUI() {
        let dismissAction = UIAction { _ in
            self.dismiss(animated: true)
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", primaryAction: dismissAction)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인")
    }
}