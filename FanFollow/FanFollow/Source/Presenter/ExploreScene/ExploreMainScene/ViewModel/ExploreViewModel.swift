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
    }
    
    struct Output {
        var exploreSectionModel: Observable<[ExploreSectionModel]>
    }
    
    var disposeBag = DisposeBag()
    private let exploreUseCase: ExploreUseCase
    
    init(exploreUseCase: ExploreUseCase) {
        self.exploreUseCase = exploreUseCase
    }
    
    func transform(input: Input) -> Output {
        // About viewWillAppear Input
        let recommandAllCreators = input.viewWillAppear
            .flatMapLatest {
                return self.exploreUseCase.fetchRandomCreatorsByAllCategory(count: 20)
            }
        
        let recommandAllCreatorsSectionModel = convertCreatorSectionModel(from: recommandAllCreators)
        
        let jobAllcase = JobCategory.allCases.filter { $0 != .unSetting }
        
        let jobCategoryObservable = convertCategorySectionModel(from: Observable.just(jobAllcase))
        let exploreSectionModel = Observable.combineLatest(
            jobCategoryObservable, recommandAllCreatorsSectionModel
        ) { categories, recommand in
            return categories + recommand
        }
        
        return Output(exploreSectionModel: exploreSectionModel)
    }
}

// Convert Method
private extension ExploreViewModel {
    func convertCreatorSectionModel(
        from observable: Observable<[(String, [Creator])]>
    ) -> Observable<[ExploreSectionModel]> {
        return observable.map { datas in
            datas.filter({ (_, creators) in
                return !creators.isEmpty
            })
            .map { (job, creators) in
                let sectionItem = creators.map { ExploreSectionItem.generateCreator(with: $0) }
                let title = String(format: Constants.Text.recommendCreatorTitleFormat, job)
                return ExploreSectionModel(title: title, items: sectionItem)
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
            
            return [ExploreSectionModel(title: Constants.Text.categoryTitle, items: sectionItem)]
        }
    }
}
