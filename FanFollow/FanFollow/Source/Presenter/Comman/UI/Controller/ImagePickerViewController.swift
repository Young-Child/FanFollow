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
    
    private func configureUI() {
        let dismissAction = UIAction { _ in
            self.dismiss(animated: true)
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Constants.Text.cancel, primaryAction: dismissAction)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.Text.confirm)
    }
}
