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
    
    private let titleTextField = UnderLineTextField().then {
        $0.placeholder = Constants.content
        $0.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    private let contentsLabel = UILabel().then {
        $0.text = Constants.content
        $0.font = .systemFont(ofSize: 22, weight: .bold)
    }
    
    private let contentsTextView = UnderLineTextView().then {
        $0.textView.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    private let uploadStackView = UIStackView().then {
        $0.spacing = 10
        $0.alignment = .fill
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    // Properties
    weak var coordinator: UploadCoordinator?
    private let viewModel: UploadViewModel
    private var registerImage: [UIImage] = []
    
    // Initializer
    init(viewModel: UploadViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNavgationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        photoCollectionView.reloadData()
    }
}

// UICollectionView Layout Method
extension UploadPhotoViewController {
    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        let collectionCellWidth = UIScreen.main.bounds.width / 2 - 30
        
        layout.itemSize  = CGSize(width: collectionCellWidth, height: collectionCellWidth)
        
        return layout
    }
}

extension UploadPhotoViewController: UploadCropImageDelegate {
    func uploadCropImage(_ image: UIImage) {
        self.registerImage.append(image)
    }
}

extension UploadPhotoViewController: UploadImageCellDelegate {
    func uploadImageCell() {
        coordinator?.presentImagePickerViewController(cropImageDelegate: self)
    }
}

// UICollectionViewDelegate, DataSource Method
extension UploadPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell: UploadImageCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        
        cell.pickerDelegate = self
        
        if indexPath.item == registerImage.count {
            cell.createButton()
        } else {
            let image = registerImage[indexPath.item]
            cell.configureCell(image)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return registerImage.count < 5 ? registerImage.count + 1 : 5
    }
}

// Configure UI
private extension UploadPhotoViewController {
    func configureNavgationBar() {
        title = Constants.navigationTitle
        navigationController?.navigationBar.standardAppearance.backgroundColor = .white
        
        let backLeftButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self, 
            action: nil
        )
        
        let uploadRightButton = UIBarButtonItem(
            title: Constants.register,
            style: .done,
            target: self,
            action: nil
        )
        
        navigationItem.leftBarButtonItem = backLeftButton
        navigationItem.rightBarButtonItem = uploadRightButton
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        configureHierarchy()
        configureCollectionView()
        makeConstraints()
    }
    
    func configureCollectionView() {
        photoCollectionView.collectionViewLayout = createLayout()
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
    }
    
    func configureHierarchy() {
        [titleLabel, titleTextField, contentsLabel, contentsTextView]
            .forEach(uploadStackView.addArrangedSubview(_:))
        [photoCollectionView, uploadStackView].forEach(view.addSubview(_:))
    }
    
    func makeConstraints() {
        photoCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
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
        static let navigationTitle = "게시물 작성"
        static let register = "완료"
    }
}
