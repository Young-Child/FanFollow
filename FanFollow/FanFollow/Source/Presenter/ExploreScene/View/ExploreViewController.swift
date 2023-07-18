//
//  ExploreViewController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/17.
//

import UIKit
import RxSwift

final class ExploreViewController: UIViewController {
    // View Properties
    private let exploreCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    ).then {
        $0.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        $0.register(CreatorCell.self, forCellWithReuseIdentifier: CreatorCell.reuseIdentifier)
        $0.backgroundColor = .clear
    }
    
    // Properties
    private let viewModel: ExploreViewModel
    private let disposeBag = DisposeBag()
    
    // Initializer
    init(viewModel: ExploreViewModel) {
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
extension ExploreViewController {
    func binding() {
        let output = bindingInput()
        
        bindCollectionView(output)
    }
    
    func bindCollectionView(_ output: ExploreViewModel.Output) {        
        output.exploreSectionModel
            .debug()
            .asDriver(onErrorJustReturn: [])
            .drive(exploreCollectionView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: disposeBag)
    }
    
    func bindingInput() -> ExploreViewModel.Output {
        let viewWillAppearEvent = rx.methodInvoked(#selector(viewWillAppear))
            .map { _ in }.asObservable()
        
        let viewByJob = Observable.from(JobCategory.allCases)
        let input = ExploreViewModel.Input(viewWillAppear: viewWillAppearEvent, viewByJob: viewByJob)
        
        return viewModel.transform(input: input)
    }
}

// UICollectionView Layout Method
extension ExploreViewController {
    private func createCategorySection(item: NSCollectionLayoutItem) -> NSCollectionLayoutSection {
        let categoryGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.1)
        )

        let categoryGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: categoryGroupSize,
            subitem: item,
            count: 4
        )
        
        let categorySection = NSCollectionLayoutSection(group: categoryGroup)
        categorySection.interGroupSpacing = 10

        return categorySection
    }
    
    private func createCreatorSection(item: NSCollectionLayoutItem) -> NSCollectionLayoutSection {
        let creatorGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.3),
            heightDimension: .fractionalHeight(0.3)
        )
        
        let creatorGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: creatorGroupSize,
            subitems: [item]
        )
        
        let creatorSection = NSCollectionLayoutSection(group: creatorGroup)
        creatorSection.orthogonalScrollingBehavior = .continuous
        
        // Header
        let headerFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(30.0)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        creatorSection.boundarySupplementaryItems = [header]
        
        
        return creatorSection
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let commonItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let commonItem = NSCollectionLayoutItem(layoutSize: commonItemSize)
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return sectionIndex == .zero ?
            self.createCategorySection(item: commonItem) : self.createCreatorSection(item: commonItem)
        }
        
        return layout
    }
}

// Configure UI
private extension ExploreViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        exploreCollectionView.collectionViewLayout = createLayout()
        
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        view.addSubview(exploreCollectionView)
    }
    
    func makeConstraints() {
        exploreCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
