//
//  ExploreCategoryViewModel.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/19.
//

import RxSwift
import RxCocoa

final class ExploreCategoryViewModel: ViewModel {
    struct Input {
        var viewWillAppear: Observable<Void>
        var viewDidScroll: Observable<Void>
    }
    
    struct Output {
        var categoryCreatorSectionModel: Observable<[ExploreSectionModel]>
    }
    
    var disposeBag = DisposeBag()
    private let exploreUseCase: ExploreUseCase
    private let jobCategory: JobCategory
    
    // Pagination Properties
    private let creatorList = BehaviorRelay<ExploreSectionModel>(
        value: ExploreSectionModel(title: "", items: [])
    )
    private var currentPage = 1
    
    init(exploreUseCase: ExploreUseCase, jobCategory: JobCategory) {
        self.exploreUseCase = exploreUseCase
        self.jobCategory = jobCategory
    }
    
    func transform(input: Input) -> Output {
        // PopularCreator By Category
        let popularSectionModel = input.viewWillAppear
            .flatMapLatest {
                return self.exploreUseCase.fetchPopularCreators(by: self.jobCategory, count: 20)
            }
            .map {
                self.convertCreatorSectionModel(
                    type: .popular(job: self.jobCategory.categoryName),
                    creators: $0
                )
            }
        
        // AllCreator By Category
        let creatorSectionModel = Observable.merge(input.viewWillAppear, input.viewDidScroll)
            .flatMapLatest {
                return self.exploreUseCase.fetchCreators(
                    by: self.jobCategory,
                    startRange: self.creatorList.value.items.count,
                    endRange: self.creatorList.value.items.count + 3
                )
            }
            .map {
                self.convertCreatorSectionModel(
                    type: .creator(job: self.jobCategory.categoryName),
                    creators: $0
                )
            }
            .map { datas in
                let oldValue = self.creatorList.value.items
                let newValue = datas.items
                
                // Pagination
                let newSectionModel = ExploreSectionModel(
                    title: datas.title,
                    items: oldValue + newValue
                )
                self.creatorList.accept(newSectionModel)
                
                return newSectionModel
            }
            
        // Target/ 페이지네이션할때는 creatorSectionModel만 더 받아오기
        let exploreCategorySectionModel = Observable.combineLatest(popularSectionModel, creatorSectionModel) {
            popular, creator in
            
            return [popular, creator]
        }
        
        return Output(categoryCreatorSectionModel: exploreCategorySectionModel)
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
    
    func convertCreatorSectionModel(type: Constant, creators: [Creator]) -> ExploreSectionModel {
        switch type {
        case .popular(let job):
            let items = creators.map { creator in
                return ExploreSectionItem.popular(nickName: creator.nickName, userID: creator.id)
            }
            
            return ExploreSectionModel(title: Constant.popular(job: job).title, items: items)
            
        case .creator(let job):
            let items = creators.map {
                return ExploreSectionItem.creator(nickName: $0.nickName, userID: $0.id)
            }
            
            return ExploreSectionModel(title: Constant.creator(job: job).title, items: items)
        }
    }
}
