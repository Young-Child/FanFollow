//
//  UploadImagePickerViewController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/02.
//

import UIKit

import Mantis
import RxSwift

protocol UploadCropImageDelegate: AnyObject {
    func uploadCropImage(_ image: UIImage)
}

final class UploadImagePickerViewController: ImagePickerViewController {
    private var disposeBag = DisposeBag()
    
    weak var uploadCropImageDelegate: UploadCropImageDelegate?
    
    init() {
        super.init(title: Constants.Text.imageSelectTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
}

// Bind Method
extension UploadImagePickerViewController {
    private func bind() {
        guard let rightButton = navigationItem.rightBarButtonItem else { return }
        
        rightButton.rx.tap
            .bind {
                self.moveMantis()
            }
            .disposed(by: disposeBag)
    }
}

// Mantis - CropViewControllerDelegate Method
extension UploadImagePickerViewController: CropViewControllerDelegate {
    func cropViewControllerDidCrop(
        _ cropViewController: CropViewController,
        cropped: UIImage,
        transformation: Transformation,
        cropInfo: CropInfo
    ) {
        uploadCropImageDelegate?.uploadCropImage(cropped)
        cropViewController.dismiss(animated: true) {
            self.dismiss(animated: true)
        }
    }
    
    func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
        cropViewController.dismiss(animated: true)
    }
    
    private func moveMantis() {
        guard let image = selectedImage else { return }
        var config = Mantis.Config()
        config.cropViewConfig.cropShapeType = .square
        config.cropViewConfig.builtInRotationControlViewType = .slideDial()
        
        let imageCropViewController = Mantis.cropViewController(image: image, config: config)
        imageCropViewController.delegate = self
        
        present(imageCropViewController, animated: true)
    }
}
