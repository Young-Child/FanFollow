//
//  ExploreViewController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/17.
//

import UIKit
import RxSwift
import RxDataSources

final class ExploreViewController: UIViewController {
    typealias ExploreDataSource = RxCollectionViewSectionedReloadDataSource<ExploreSectionModel>
    
    // View Properties
    private let exploreCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    ).then {
        $0.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        $0.register(CreatorCell.self, forCellWithReuseIdentifier: CreatorCell.reuseIdentifier)
        $0.register(
            ExploreCollectionReusableHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ExploreCollectionReusableHeaderView.reuseIdentifier
        )
        $0.backgroundColor = .clear
    }
    
    // Properties
    private let viewModel: ExploreViewModel
    private let dataSource = ExploreViewController.dataSource()
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
            .asDriver(onErrorJustReturn: [])
            .drive(exploreCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    func bindingInput() -> ExploreViewModel.Output {
        let viewWillAppearEvent = rx.methodInvoked(#selector(viewWillAppear))
            .map { _ in }
            .asObservable()
        
        let collectionViewTouchEvent = exploreCollectionView.rx.modelSelected(ExploreSectionItem.self)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asObservable()
        
        let input = ExploreViewModel.Input(
            viewWillAppear: viewWillAppearEvent,
            viewByJopCategory: collectionViewTouchEvent
        )
        
        return viewModel.transform(input: input)
    }
}

// DataSource From RxDataSource
extension ExploreViewController {
    static func dataSource() -> ExploreDataSource {
        let dataSource: ExploreDataSource = ExploreDataSource { dataSource, collectionView, indexPath, item in
            switch item {
            case .category(let job):
                let cell: CategoryCell = collectionView.dequeueReuseableCell(forIndexPath: indexPath)
                cell.configureCell(jobCategory: job)
                
                return cell
            case .creator(let nickName, let userID):
                let cell: CreatorCell = collectionView.dequeueReuseableCell(forIndexPath: indexPath)
                cell.configureCell(nickName: nickName, userID: userID)
                
                return cell
            }
        } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let headerView: ExploreCollectionReusableHeaderView = collectionView
                    .dequeueReusableSupplementaryView(forIndexPath: indexPath, kind: kind)
                
                let sectionTitle = dataSource.sectionModels[indexPath.section].title
                headerView.bind(title: sectionTitle)
                
                return headerView
            default:
                fatalError()
            }
        }
        
        return dataSource
    }
}

// UICollectionView Layout Method
extension ExploreViewController {
    private func createCategorySection(item: NSCollectionLayoutItem) -> NSCollectionLayoutSection {
        let categoryGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.07)
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
            heightDimension: .fractionalHeight(0.2)
        )
        
        let creatorGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: creatorGroupSize,
            subitems: [item]
        )
        
        let creatorSection = NSCollectionLayoutSection(group: creatorGroup)
        creatorSection.orthogonalScrollingBehavior = .continuous
        
        return creatorSection
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let commonItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let commonItem = NSCollectionLayoutItem(layoutSize: commonItemSize)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50.0)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            let section = sectionIndex == .zero ?
            self.createCategorySection(item: commonItem) : self.createCreatorSection(item: commonItem)
            section.boundarySupplementaryItems = [header]
            
            return section
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
