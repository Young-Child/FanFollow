//
//  ExploreViewModel.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/17.
//

import RxSwift
import RxDataSources
import RxCocoa

final class ExploreViewModel: ViewModel {
    typealias ExploreDataSource = RxCollectionViewSectionedReloadDataSource<ExploreSectionModel>
    
    struct Input {
        var viewWillAppear: Observable<Void>
        var viewByJob: Observable<JobCategory>
    }
    
    struct Output {
        var exploreSectionModel: Observable<[ExploreSectionModel]>
        var popularCreatorsByJob: Observable<[Creator]>
        var allCreatorsByJob: Observable<[Creator]>
    }
    
    var disposeBag = DisposeBag()
    
    let dataSource: ExploreDataSource = {
        let dataSource = ExploreDataSource { dataSource, collectionView, indexPath, item in
            switch item {
            case .category(let job):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CategoryCell.reuseIdentifier,
                    for: indexPath
                ) as? CategoryCell
                else {
                    fatalError()
                }
                
                cell.configureCell(jobCategory: job)
                
                return cell
            case .creator(let nickName, let userID):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CreatorCell.reuseIdentifier,
                    for: indexPath
                ) as? CreatorCell
                else {
                    fatalError()
                }
                
                cell.configureCell(nickName: nickName, userID: userID)
                
                return cell
            }
        }
        
        return dataSource
    }()
    
    
    private let exploreUseCase: ExploreUseCase
    
    init(exploreUseCase: ExploreUseCase) {
        self.exploreUseCase = exploreUseCase
    }
    
    func transform(input: Input) -> Output {
        let recommandAllCreators = input.viewWillAppear
            .flatMapLatest {
                return self.exploreUseCase.fetchRandomAllCreators(count: 20)
            }
        
        let recommandAllCreatorsSectionModel = convertCreatorSectionModel(from: recommandAllCreators)
        let jobCategoryObservable = convertCategorySectionModel(from: Observable.just(JobCategory.allCases))
        let exploreSectionModel = Observable.combineLatest(
            jobCategoryObservable, recommandAllCreatorsSectionModel
        ) { categories, recommand in
            return categories + recommand
        }
        
        let popularCreatorsByJob = input.viewByJob
            .flatMapLatest { jobCategory in
                return self.exploreUseCase.fetchPopularCreators(jobCategory: jobCategory, count: 20)
            }
        
        let allCreatorsByJob = input.viewByJob
            .flatMapLatest { jobCategory in
                return self.exploreUseCase.fetchRandomCreators(jobCategory: jobCategory, count: 20)
            }
        
        return Output(
            exploreSectionModel: exploreSectionModel,
            popularCreatorsByJob: popularCreatorsByJob,
            allCreatorsByJob: allCreatorsByJob
        )
    }
    
    private func convertCreatorSectionModel(
        from observable: Observable<[(String, [Creator])]>
    ) -> Observable<[ExploreSectionModel]> {
        return observable.map { datas in
            datas.map { (jobCategory, creators) in
                let sectionItem = creators.map {
                    ExploreSectionItem.creator(nickName: $0.nickName, userID: $0.id)
                }
                
                return ExploreSectionModel(title: jobCategory, items: sectionItem)
            }
        }
    }
    
    private func convertCategorySectionModel(
        from observable: Observable<[JobCategory]>
    ) -> Observable<[ExploreSectionModel]> {
        return observable.map { datas in
            let sectionItem = datas.map { jobCategory in
                return ExploreSectionItem.category(job: jobCategory)
            }
            
            return [ExploreSectionModel(title: "category", items: sectionItem)]
        }
    }

}
