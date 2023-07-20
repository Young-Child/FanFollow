//
//  ExploreCategoryViewModel.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/19.
//

import RxSwift

final class ExploreCategoryViewModel: ViewModel {
    struct Input {
        var viewWillAppear: Observable<Void>
    }
    
    struct Output {
        var categoryCreatorSectionModel: Observable<[ExploreSectionModel]>
    }
    
    var disposeBag = DisposeBag()
    private let exploreUseCase: ExploreUseCase
    private let jobCategory: JobCategory
    
    init(exploreUseCase: ExploreUseCase, jobCategory: JobCategory) {
        self.exploreUseCase = exploreUseCase
        self.jobCategory = jobCategory
    }
    
    func transform(input: Input) -> Output {
        // About PopularCreator By Category
        let popularCreatorsByJob = input.viewWillAppear
            .flatMapLatest {
                return self.exploreUseCase.fetchPopularCreators(by: self.jobCategory, count: 20)
            }
        let popularSectionModel = convertCreatorSectionModel(
            type: .popular(job: self.jobCategory.categoryName),
            from: popularCreatorsByJob
        )
        
        // About AllCreator By Category
        let allCreatorsByJob = input.viewWillAppear
            .flatMapLatest {
                return self.exploreUseCase.fetchRandomCreators(by: self.jobCategory, count: 10)
            }
        
        let creatorSectionModel = convertCreatorSectionModel(
            type: .creator(job: self.jobCategory.categoryName),
            from: allCreatorsByJob
        )
        
        return Output(
            categoryCreatorSectionModel: Observable.concat(popularSectionModel, creatorSectionModel)
        )
    }
}

// Convert Method & Constant
private extension ExploreCategoryViewModel {
    enum Constant {
        case popular(job: String)
        case creator(job: String)
        
        var title: String {
            switch self {
            case .popular(let job):
                return "인기 \(job) 크리에이터"
            case .creator(let job):
                return "전체 \(job) 크리에이터"
            }
        }
    }
    
    func convertCreatorSectionModel(
        type: Constant,
        from observable: Observable<[Creator]>
    ) -> Observable<[ExploreSectionModel]> {
        switch type {
        case .popular(let job):
            return observable.map { datas in
                let sectionItem = datas.map { creator in
                    return ExploreSectionItem.popular(nickName: creator.nickName, userID: creator.id)
                }
                
                return [ExploreSectionModel(title: Constant.popular(job: job).title, items: sectionItem)]
            }
        case .creator(let job):
            return observable.map { datas in
                let sectionItem = datas.map { creator in
                    return ExploreSectionItem.creator(nickName: creator.nickName, userID: creator.id)
                }
                
                return [ExploreSectionModel(title: Constant.creator(job: job).title, items: sectionItem)]
            }
        }
    }
}
