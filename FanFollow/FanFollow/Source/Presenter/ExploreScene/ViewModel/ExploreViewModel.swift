//
//  ExploreViewModel.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/17.
//

import RxSwift

final class ExploreViewModel: ViewModel {
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
}

// Convert Method & Constant
private extension ExploreViewModel {
    private enum Constant {
        case creator(job: String)
        case category
        
        var title: String {
            switch self {
            case .creator(let job):
                return "추천 \(job) 크리에이터"
            case .category:
                return "카테고리로 보기"
            }
        }
    }
    
    func convertCreatorSectionModel(
        from observable: Observable<[(String, [Creator])]>
    ) -> Observable<[ExploreSectionModel]> {
        return observable.map { datas in
            datas.filter({ (_, creators) in
                return !creators.isEmpty
            })
            .map { (job, creators) in
                let sectionItem = creators.map {
                    ExploreSectionItem.creator(nickName: $0.nickName, userID: $0.id)
                }
                
                return ExploreSectionModel(title: Constant.creator(job: job).title, items: sectionItem)
            }
        }
    }
    
    func convertCategorySectionModel(
        from observable: Observable<[JobCategory]>
    ) -> Observable<[ExploreSectionModel]> {
        return observable.map { datas in
            let sectionItem = datas.map { jobCategory in
                return ExploreSectionItem.category(job: jobCategory)
            }
            
            return [ExploreSectionModel(title: Constant.category.title, items: sectionItem)]
        }
    }
}
