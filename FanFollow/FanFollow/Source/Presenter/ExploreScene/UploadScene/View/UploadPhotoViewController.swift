//
//  UploadPhotoViewController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/01.
//

import UIKit
import RxSwift

final class UploadPhotoViewController: UIViewController {
    // View Properties
    private let photoCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then { collectionView in
        collectionView.layer.backgroundColor = UIColor.systemBackground.cgColor
        collectionView.register(
            UploadImageCell.self,
            forCellWithReuseIdentifier: UploadImageCell.reuseIdentifier
        )
    }
    
    private let titleLabel = UILabel().then {
        $0.text = Constants.title
        $0.font = .systemFont(ofSize: 22, weight: .bold)
    }
    
    private let titleTextField = UITextField().then {
        $0.placeholder = Constants.content
        $0.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    private let contentsLabel = UILabel().then {
        $0.text = Constants.content
        $0.font = .systemFont(ofSize: 22, weight: .bold)
    }
    
    private let contentsTextView = UITextView().then {
        $0.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    private let uploadStackView = UIStackView().then {
        $0.spacing = 10
        $0.alignment = .fill
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

// UICollectionView Layout Method
extension UploadPhotoViewController {
    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        let collectionCellWidth = UIScreen.main.bounds.width / 4 - 10
        
        layout.itemSize  = CGSize(width: collectionCellWidth, height: collectionCellWidth)
        
        return layout
    }
}

// Configure UI
private extension UploadPhotoViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        photoCollectionView.collectionViewLayout = createLayout()
        
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [titleLabel, titleTextField, contentsLabel, contentsTextView]
            .forEach(uploadStackView.addArrangedSubview(_:))
        [photoCollectionView, uploadStackView].forEach(view.addSubview(_:))
    }
    
    func makeConstraints() {
        photoCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.height.equalTo(240)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        uploadStackView.snp.makeConstraints {
            $0.top.equalTo(photoCollectionView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
}

// Constants
private extension UploadPhotoViewController {
    enum Constants {
        static let title = "제목"
        static let content = "내용"
        static let titlePlaceholder = "제목을 작성해보세요."
        static let contentPlaceholder = "글을 작성해보세요."
    }
}
