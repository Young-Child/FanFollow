//
//  ExploreSearchViewController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/23.
//

import UIKit

import RxRelay
import RxSwift

final class ExploreSearchViewController: UIViewController {
    // View Properties
    private let backButton = UIButton().then {
        $0.tintColor = Constants.Color.blue
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 22)
        let image = Constants.Image.back?.withConfiguration(imageConfiguration)
        $0.setImage(image, for: .normal)
    }
    
    private let searchBar = UISearchBar().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Constants.Color.background.cgColor
        $0.barTintColor = .systemBackground
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.tintColor = Constants.Color.blue
        $0.searchTextField.textColor = .label
        $0.searchTextField.clearButtonMode = .whileEditing
        $0.searchTextField.leftView = nil
        $0.searchTextField.backgroundColor = .systemGray5
        $0.setImage(Constants.Image.xmark, for: .clear, state: .normal)
        $0.searchTextField.attributedPlaceholder = NSAttributedString(
            string: ConstantsExplore.searchPlaceHolder,
            attributes: [NSAttributedString.Key.foregroundColor: Constants.Color.grayDark]
        )
    }
    
    private let searchTableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorColor = .lightGray
        $0.separatorInset = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero)
        $0.backgroundColor = .clear
        $0.register(CreatorListCell.self, forCellReuseIdentifier: CreatorListCell.reuseIdentifier)
    }
    
    private let searchLabel = UILabel().then {
        $0.textColor = .label
        $0.textAlignment = .center
        $0.text = ConstantsExplore.noSearchResult
    }
    
    // Properties
    weak var coordinator: ExploreCoordinator?
    private let viewModel: ExploreSearchViewModel
    private let disposeBag = DisposeBag()
    private var isLoading = BehaviorRelay<Bool>(value: false)
    
    // Initializer
    init(viewModel: ExploreSearchViewModel) {
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
        binding()
    }
}

// Binding
extension ExploreSearchViewController: UISearchBarDelegate {
    func binding() {
        let output = bindingInput()
        
        bindBackButton()
        bindSearchBar()
        bindTableView(output)
    }
    
    private func bindBackButton() {
        backButton.rx.tap
            .bind { self.coordinator?.close(to: self) }
            .disposed(by: disposeBag)
    }
    
    private func bindSearchBar() {
        searchBar.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindTableView(_ output: ExploreSearchViewModel.Output) {
        let creatorResult = output.searchCreatorResultModel
            .asDriver(onErrorJustReturn: [])
        
        let isFullResult = creatorResult.map { $0.isEmpty == false }
        
        creatorResult
            .drive(searchTableView.rx.items(
                cellIdentifier: CreatorListCell.reuseIdentifier,
                cellType: CreatorListCell.self)
            ) { indexPath, creator, cell in
                cell.configureCell(creator: creator)
            }
            .disposed(by: disposeBag)
        
        isFullResult
            .drive(self.searchLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        isFullResult
            .map { $0 == false ? ConstantsExplore.noSearchResult : "" }
            .drive(self.searchLabel.rx.text)
            .disposed(by: disposeBag)
        
        searchTableView.rx.modelSelected(Creator.self)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind { item in
                guard let indexPath = self.searchTableView.indexPathForSelectedRow else { return }
                
                self.searchBar.endEditing(true)
                self.searchTableView.deselectRow(at: indexPath, animated: true)
                self.coordinator?.presentProfileViewController(to: item.id)
            }
            .disposed(by: disposeBag)
        
        searchTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    func bindingInput() -> ExploreSearchViewModel.Output {
        let searchBarEvent = searchBar.rx.text
            .distinctUntilChanged()
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .asObservable()
        
        let viewDidScrollEvent = searchTableView.rx.didScroll
            .flatMap { _ in
                if self.isLoading.value { return Observable<Void>.empty() }
                
                let collectionViewContentSizeY = self.searchTableView.contentSize.height
                let contentOffsetY = self.searchTableView.contentOffset.y
                let heightRemainBottomHeight = collectionViewContentSizeY - contentOffsetY
                let frameHeight = self.searchTableView.frame.size.height
                let reachBottom = heightRemainBottomHeight < frameHeight
                
                self.isLoading.accept(reachBottom)
                
                return reachBottom ? Observable<Void>.just(()) : Observable<Void>.empty()
            }
            .asObservable()
        
        let input = ExploreSearchViewModel.Input(
            textDidSearch: searchBarEvent,
            viewDidScroll: viewDidScrollEvent
        )
        
        return viewModel.transform(input: input)
    }
}

extension ExploreSearchViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
}

// Configure UI
private extension ExploreSearchViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [backButton, searchBar, searchTableView, searchLabel].forEach { view.addSubview($0) }
    }
    
    func makeConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            $0.leading.equalTo(backButton.snp.trailing)
            $0.trailing.equalToSuperview().inset(8)
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalTo(searchBar.snp.centerY)
            $0.leading.equalToSuperview().inset(8)
        }
        
        searchTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        searchLabel.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
    }
}

// Constants
private extension ExploreSearchViewController {
    enum ConstantsExplore {
        static let searchPlaceHolder = "크리에이터의 닉네임을 검색해보세요."
//        static let clearImage = "xmark"
//        static let backImage = "chevron.backward"
        static let noSearch = "크리에이터의 닉네임을 검색해보세요."
        static let noSearchResult = "검색 결과가 없습니다."
    }
}
