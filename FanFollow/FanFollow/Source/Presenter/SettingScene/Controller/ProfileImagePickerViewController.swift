//
//  ProfileImagePickerViewController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class ProfileImagePickerViewController: PhotoAssetGridViewController {
    private var maxImageCount: Int
    private var selectedImage: UIImage?
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
    }
}

private extension ProfileImagePickerViewController {
    func configureUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인")
    }
}
