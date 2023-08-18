//
//  ExploreCategoryViewController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/19.
//

import UIKit

import RxDataSources
import RxSwift

final class ExploreCategoryViewController: UIViewController {
    typealias ExploreCategoryDataSource = RxCollectionViewSectionedReloadDataSource<ExploreSectionModel>
    
    // View Properties
    private let navigationBar = FFNavigationBar()
    
    private let exploreCategoryCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    ).then {
        $0.register(CreatorCell.self, forCellWithReuseIdentifier: CreatorCell.reuseIdentifier)
        $0.register(
            ExploreCollectionReusableHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ExploreCollectionReusableHeaderView.reuseIdentifier
        )
        $0.backgroundColor = .clear
    }
    
    // Properties
    weak var coordinator: ExploreCoordinator?
    private let viewModel: ExploreCategoryViewModel
    private let dataSource = ExploreCategoryViewController.dataSource()
    private let disposeBag = DisposeBag()
    
    // Initializer
    init(viewModel: ExploreCategoryViewModel) {
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
extension ExploreCategoryViewController {
    func binding() {
        let output = bindingInput()
        
        bindCollectionView(output)
        bindingNavigationBar()
    }
    
    func bindCollectionView(_ output: ExploreCategoryViewModel.Output) {
        output.categoryCreatorSectionModel
            .asDriver(onErrorJustReturn: [])
            .drive(exploreCategoryCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        exploreCategoryCollectionView.rx.modelSelected(ExploreSectionItem.self)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind { item in
                switch item {
                case .creator(_, let creatorID, _):
                    self.coordinator?.presentProfileViewController(to: creatorID)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }

    func bindingNavigationBar() {
        navigationBar.leftBarButton.rx.tap
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                self.coordinator?.close(to: self)
            })
            .disposed(by: disposeBag)
    }
    
    func bindingInput() -> ExploreCategoryViewModel.Output {
        let viewWillAppearEvent = rx.methodInvoked(#selector(viewWillAppear))
            .map { _ in }
            .asObservable()
        
        let viewDidScrollEvent = exploreCategoryCollectionView.rx.didScroll
            .flatMap{ _ in
                let collectionViewContentSizeY = self.exploreCategoryCollectionView.contentSize.height
                let contentOffsetY = self.exploreCategoryCollectionView.contentOffset.y
                let heightRemainBottomHeight = collectionViewContentSizeY - contentOffsetY
                let frameHeight = self.exploreCategoryCollectionView.frame.size.height
                let reachBottom = heightRemainBottomHeight < frameHeight
                
                return reachBottom ? Observable<Void>.just(()) : Observable<Void>.empty()
            }
            .asObservable()
                
        let input = ExploreCategoryViewModel.Input(
            viewWillAppear: viewWillAppearEvent,
            viewDidScroll: viewDidScrollEvent
        )
        
        return viewModel.transform(input: input)
    }
}

// DataSource From RxDataSource
extension ExploreCategoryViewController {
    static func dataSource() -> ExploreCategoryDataSource {
        let dataSource = ExploreCategoryDataSource { dataSource, collectionView, indexPath, item in
            
            if case let .creator(nickName, userID, profileURL) = item {
                let cell: CreatorCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                cell.configureCell(nickName: nickName, userID: userID, profileURL: profileURL)
                
                return cell
            }
            
            return CreatorCell()
            
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
extension ExploreCategoryViewController {
    private func createPopularSection(item: NSCollectionLayoutItem) -> NSCollectionLayoutSection {
        let popularCreatorGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.3),
            heightDimension: .fractionalHeight(0.2)
        )
        
        let popularCreatorGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: popularCreatorGroupSize,
            subitems: [item]
        )
        
        let popularSection = NSCollectionLayoutSection(group: popularCreatorGroup)
        popularSection.orthogonalScrollingBehavior = .continuous
        
        return popularSection
    }
    
    private func createCreatorSection(item: NSCollectionLayoutItem) -> NSCollectionLayoutSection {
        let creatorGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.2)
        )
        
        let creatorGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: creatorGroupSize,
            subitem: item,
            count: 3
        )
        
        let creatorSection = NSCollectionLayoutSection(group: creatorGroup)
        creatorSection.interGroupSpacing = 8
        
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
            self.createPopularSection(item: commonItem) : self.createCreatorSection(item: commonItem)
            section.boundarySupplementaryItems = [header]
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            return section
        }
        
        return layout
    }
}

// Configure UI
private extension ExploreCategoryViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        exploreCategoryCollectionView.collectionViewLayout = createLayout()
        
        configureNavigationBar()
        configureHierarchy()
        makeConstraints()
    }
    
    func configureNavigationBar() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 22)
        let backButton = Constants.Image.back?.withConfiguration(configuration)
        navigationBar.leftBarButton.setImage(backButton, for: .normal)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func configureHierarchy() {
        [navigationBar, exploreCategoryCollectionView].forEach(view.addSubview(_:))
    }
    
    func makeConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        exploreCategoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension ExploreCategoryViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
