//
//  ImagePickerViewController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/02.
//

import UIKit

class ImagePickerViewController: PhotoAssetGridViewController {
    var selectedImage: UIImage?

    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? AssetImageGridCell
        cell?.setSelected(to: false)
    }
    
    private func configureUI() {
        let dismissAction = UIAction { _ in
            self.dismiss(animated: true)
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", primaryAction: dismissAction)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인")
        navigationItem.title = title
    }
}
