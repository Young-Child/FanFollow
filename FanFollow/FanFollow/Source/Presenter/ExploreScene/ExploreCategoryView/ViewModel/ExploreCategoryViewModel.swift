//
//  ExploreCategoryViewModel.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/19.
//

import RxCocoa
import RxSwift

final class ExploreCategoryViewModel: ViewModel {
    struct Input {
        var viewWillAppear: Observable<Void>
        var viewDidScroll: Observable<Void>
    }
    
    struct Output {
        var categoryCreatorSectionModel: Observable<[ExploreSectionModel]>
    }
    
    var disposeBag = DisposeBag()
    private let exploreUseCase: FetchExploreUseCase
    private let jobCategory: JobCategory
    
    // Pagination Properties
    private let creatorList = BehaviorRelay<ExploreSectionModel>(
        value: ExploreSectionModel(title: "", items: [])
    )
    
    init(exploreUseCase: FetchExploreUseCase, jobCategory: JobCategory) {
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
                    type: .popular,
                    creators: $0
                )
            }
        
        // AllCreator By Category
        let creatorSectionModel = Observable.merge(input.viewWillAppear, input.viewDidScroll)
            .flatMapLatest {
                return self.exploreUseCase.fetchCreators(
                    by: self.jobCategory,
                    startRange: self.creatorList.value.items.count,
                    endRange: self.creatorList.value.items.count + 10
                )
            }
            .map {
                self.convertCreatorSectionModel(
                    type: .creator,
                    creators: $0
                )
            }
            .map { datas in
                let prevSectionItem = self.creatorList.value.items
                let newSectionItem = datas.items
                
                // Pagination
                let newSectionModel = ExploreSectionModel(
                    title: datas.title,
                    items: prevSectionItem + newSectionItem
                )
                self.creatorList.accept(newSectionModel)
                
                return newSectionModel
            }
            
        // Target
        let exploreCategorySectionModel = Observable.combineLatest(
            popularSectionModel,
            creatorSectionModel
        ) { popular, creator in
            return [popular, creator]
        }
        
        return Output(categoryCreatorSectionModel: exploreCategorySectionModel)
    }
}

// Convert Method & ExploreCategoryType
private extension ExploreCategoryViewModel {
    enum ExploreCategoryType: String {
        case popular = "인기"
        case creator = "전체"
    }
    
    func convertCreatorSectionModel(
        type: ExploreCategoryType,
        creators: [Creator]
    ) -> ExploreSectionModel {
        let items = creators.map { creator in
            return ExploreSectionItem.creator(
                nickName: creator.nickName,
                userID: creator.id,
                profileURL: creator.profileURL
            )
        }
        
        let title = type.rawValue + String(
            format: Constants.Text.creatorFormat,
            self.jobCategory.categoryName
        )
        
        return ExploreSectionModel(title: title, items: items)
    }
}
