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
        collectionView.layer.backgroundColor = UIColor.systemBackground.cgColor
        collectionView.register(
            AssetImageGridCell.self,
            forCellWithReuseIdentifier: AssetImageGridCell.reuseIdentifier
        )
    }
    
    // Properties
    private var photos: PHFetchResult<PHAsset>?
    private let scale = UIScreen.main.scale
    private var thumbnailSize = CGSize.zero
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        configureUI()
        
        let option = PHFetchOptions()
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        self.photos = PHAsset.fetchAssets(with: .image, options: option)
        self.collectionView.reloadData()
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
        let cell: AssetImageGridCell = collectionView.dequeReusableCell(forIndexPath: indexPath)
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
