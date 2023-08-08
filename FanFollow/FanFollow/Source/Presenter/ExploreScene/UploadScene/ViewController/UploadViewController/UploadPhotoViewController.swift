//
//  UploadPhotoViewController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/01.
//

import UIKit
import RxSwift
import RxCocoa

import Kingfisher

final class UploadPhotoViewController: UploadViewController {
    // View Properties
    private let photoCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then { collectionView in
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: .zero, left: 8, bottom: .zero, right: 8)
        collectionView.layer.backgroundColor = UIColor.systemBackground.cgColor
        collectionView.register(
            UploadImageCell.self,
            forCellWithReuseIdentifier: UploadImageCell.reuseIdentifier
        )
    }
    
    private let uploadStackView = UIStackView().then {
        $0.spacing = 16
        $0.alignment = .fill
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    // Properties
    private let disposeBag = DisposeBag()
    private var registerImage: [UIImage] = [] {
        willSet {
            imageCount.accept(newValue.count)
        }
    }
    private let imageCount = BehaviorRelay(value: 0)
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // Configure UI Method
    override func configureHierarchy() {
        super.configureHierarchy()
        [titleLabel, titleTextField, contentsLabel, contentsTextView]
            .forEach(uploadStackView.addArrangedSubview(_:))
        [photoCollectionView, uploadStackView].forEach(contentView.addSubview(_:))
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        photoCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.width / 2)
        }
        
        uploadStackView.snp.makeConstraints {
            $0.top.equalTo(photoCollectionView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview()
        }
    }
    
    override func binding() {
        super.binding()
        
        let output = bindingInput()
        bindingOutput(output)
    }
    
    override func bindingOutput(_ output: UploadViewModel.Output) {
        super.bindingOutput(output)
        
        output.postImageDatas
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: configureImages(to:))
            .disposed(by: disposeBag)
    }
}

// Binding Method
extension UploadPhotoViewController {
    func bindingInput() -> UploadViewModel.Output {
        let input = UploadViewModel.Input(registerButtonTap: configureRightButtonTapEvent())
        return viewModel.transform(input: input)
    }
    
    func configureRightButtonTapEvent() -> Observable<Upload> {
        guard let rightBarButton = navigationItem.rightBarButtonItem else { return .empty() }
        
        bindingRightBarButton(with: rightBarButton)
        
        return rightBarButton.rx.tap
            .map { _ in
                let data = self.registerImage.compactMap { $0.pngData() }
                let upload = Upload(
                    title: self.titleTextField.text ?? "",
                    content: self.contentsTextView.textView.text,
                    imageDatas: data,
                    videoURL: nil
                )
                return upload
            }
    }
    
    func bindingRightBarButton(with barButton: UIBarButtonItem) {
        let isTitleNotEmpty = titleTextField.rx.observe(String.self, "text")
            .map { $0?.count != .zero && $0 != nil }
        
        let isContentNotEmpty = contentsTextView.textView.rx.text.orEmpty.map {
            return $0.isEmpty == false && $0 != Constants.contentPlaceholder
        }
        
        Observable.combineLatest(
            isTitleNotEmpty,
            isContentNotEmpty,
            imageCount.map { $0 != .zero }
        ) { $0 && $1 && $2 }
            .bind(to: barButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}

// Crop View Controller Delegate Method
extension UploadPhotoViewController: UploadCropImageDelegate {
    func uploadCropImage(_ image: UIImage) {
        self.registerImage.append(image)
        photoCollectionView.reloadData()
    }
}

// Upload Image Cell Delegate
extension UploadPhotoViewController: UploadImageCellDelegate {
    func uploadImageCell(didTapPickImage cell: UploadImageCell) {
        coordinator?.presentImagePickerViewController(cropImageDelegate: self)
    }
    
    func uploadImageCell(didTapRemoveImage cell: UploadImageCell) {
        print(cell)
    }
}

// UICollectionViewDelegate, DataSource Method
extension UploadPhotoViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell: UploadImageCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        let isButton = indexPath.item == registerImage.count
        let image = registerImage[safe: indexPath.item]
        
        cell.pickerDelegate = self
        cell.configure(with: isButton, image: image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if registerImage.count >= 5 { return registerImage.count }
        return registerImage.count + 1
    }
}

// UI Update Method
private extension UploadPhotoViewController {
    func configureImages(to imageDatas: [Data]) {
        self.registerImage = imageDatas.compactMap { UIImage(data: $0) }
        photoCollectionView.reloadData()
    }
    
    func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        let collectionCellWidth = UIScreen.main.bounds.width / 2 - 30
        
        layout.itemSize  = CGSize(width: collectionCellWidth, height: collectionCellWidth)
        
        return layout
    }
}

// Configure UI
private extension UploadPhotoViewController {
    func configureUI() {
        configureNavigationBar()
        configureHierarchy()
        configureCollectionView()
        makeConstraints()
    }
    
    func configureCollectionView() {
        photoCollectionView.collectionViewLayout = createLayout()
        photoCollectionView.dataSource = self
    }
}

// Constants
private extension UploadPhotoViewController {
    enum Constants {
        static let title = "제목"
        static let content = "내용"
        static let titlePlaceholder = "제목을 입력해주세요."
        static let contentPlaceholder = "내용을 입력해주세요."
        static let navigationTitle = "게시물 작성"
        static let register = "완료"
    }
}
