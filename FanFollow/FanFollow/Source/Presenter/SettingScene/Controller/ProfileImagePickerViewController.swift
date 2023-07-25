//
//  ProfileImagePickerViewController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

protocol ProfileImagePickerDelegate: AnyObject {
    func profileImagePickerViewController(
        to pickerController: ProfileImagePickerViewController,
        didSelectedImage image: UIImage?
    )
}

final class ProfileImagePickerViewController: PhotoAssetGridViewController {
    private var maxImageCount: Int
    private var selectedImage: UIImage?
    
    weak var delegate: ProfileImagePickerDelegate?
    
    init(maxImageCount: Int = 1) {
        self.maxImageCount = maxImageCount
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.maxImageCount = 1
        super.init(coder: coder)
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
    func configureUI() {
        let cancelAction = UIAction { _ in
            self.dismiss(animated: true)
        }
        
        let confirmAction = UIAction { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.profileImagePickerViewController(
                to: self,
                didSelectedImage: self.selectedImage
            )
            self.dismiss(animated: true)
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", primaryAction: cancelAction)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인", primaryAction: confirmAction)
    }
}
