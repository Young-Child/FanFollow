//
//  PhotoAssetGridViewController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import Photos

class PhotoAssetGridViewController: UIViewController {
    // View Properties
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then { collectionView in
        collectionView.layer.backgroundColor = Constants.Color.background.cgColor
        collectionView.register(
            AssetImageGridCell.self,
            forCellWithReuseIdentifier: AssetImageGridCell.reuseIdentifier
        )
    }
    
    // Properties
    private var photos: PHFetchResult<PHAsset>?
    private let scale = UIScreen.main.scale
    private var thumbnailSize = CGSize.zero
    
    // Deinit
    deinit { PHPhotoLibrary.shared().unregisterChangeObserver(self) }
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        configureLibraryImages()
        configureUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let width = view.bounds.inset(by: view.safeAreaInsets).width
        
        let columnCount = (width / 90).rounded(.towardZero)
        let itemLength = (width - columnCount) / columnCount
        
        self.thumbnailSize = CGSize(width: itemLength * scale, height: itemLength * scale)
    }
}

// UICollectionView DataSource Method
extension PhotoAssetGridViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return photos?.count ?? .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: AssetImageGridCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        let asset = photos?.object(at: indexPath.item) ?? PHAsset()
        
        cell.identifier = asset.localIdentifier
        
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: thumbnailSize,
            contentMode: .aspectFill,
            options: nil
        ) { image, _ in
            if cell.identifier == asset.localIdentifier {
                cell.setImage(to: image)
            }
        }
        
        return cell
    }
}

// UICollectionView Flow Layout Delegate Method
extension PhotoAssetGridViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let length = self.view.frame.width / 3 - 1.5
        return CGSize(width: length, height: length)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 1.5
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 1.5
    }
}

private extension PhotoAssetGridViewController {
    func configureLibraryImages() {
        checkPhotoAuthorization()
        
        PHPhotoLibrary.shared().register(self)
        
        let option = PHFetchOptions()
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        photos = PHAsset.fetchAssets(with: .image, options: option)
        
        collectionView.reloadData()
    }
    
    func checkPhotoAuthorization() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch status {
                case .denied, .restricted:
                    self.presentDeniedAlert()
                default:
                    return
                }
            }
        }
    }
    
    func presentDeniedAlert() {
        let alertController = UIAlertController(
            title: Constants.Text.photoAccessAlertTitle,
            message: Constants.Text.photoAccessAlertMessage,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: Constants.Text.confirm, style: .default) { _ in
            self.dismiss(animated: true)
        }
        
        alertController.addAction(action)
        
        self.present(alertController, animated: true)
    }
}

// Photo Selected Changed Observer
extension PhotoAssetGridViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let photos = photos,
              let changes = changeInstance.changeDetails(for: photos) else { return }
        
        DispatchQueue.main.sync {
            self.photos = changes.fetchResultAfterChanges
            
            if changes.hasIncrementalChanges {
                collectionView.performBatchUpdates {
                    if let removed = changes.removedIndexes,
                       removed.isEmpty == false {
                        let indexPaths = removed.map { IndexPath(item: $0, section: .zero) }
                        collectionView.deleteItems(at: indexPaths)
                    }
                    
                    if let inserted = changes.insertedIndexes,
                       inserted.isEmpty == false {
                        let indexPaths = inserted.map { IndexPath(item: $0, section: .zero)}
                        collectionView.insertItems(at: indexPaths)
                    }
                    
                    changes.enumerateMoves { from, to in
                        let fromIndexPath = IndexPath(item: from, section: .zero)
                        let toIndexPath = IndexPath(item: to, section: .zero)
                        self.collectionView.moveItem(at: fromIndexPath, to: toIndexPath)
                    }
                    
                    if let changed = changes.changedIndexes,
                       changed.isEmpty == false {
                        let indexPaths = changed.map { IndexPath(item: $0, section: .zero) }
                        collectionView.reloadItems(at: indexPaths)
                    }
                }
            }
            else {
                collectionView.reloadData()
            }
        }
    }
}

// Configuration UI
private extension PhotoAssetGridViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        view.addSubview(collectionView)
    }
    
    func makeConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
