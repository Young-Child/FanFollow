//
//  ExploreViewModel.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/17.
//

import RxSwift
import RxDataSources

final class ExploreViewModel: ViewModel {
    struct Input {
        var viewWillAppear: Observable<Void>
        var viewByJob: Observable<JobCategory>
    }
    
    struct Output {
        var recommandAllCreators: Observable<[ExploreSectionModel]>
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
        
        let recommandAllCreatorsSectionModel = convertSectionModel(from: recommandAllCreators)
        
        let popularCreatorsByJob = input.viewByJob
            .flatMapLatest { jobCategory in
                return self.exploreUseCase.fetchPopularCreators(jobCategory: jobCategory, count: 20)
            }
        
        let allCreatorsByJob = input.viewByJob
            .flatMapLatest { jobCategory in
                return self.exploreUseCase.fetchRandomCreators(jobCategory: jobCategory, count: 20)
            }
        
        return Output(
            recommandAllCreators: recommandAllCreatorsSectionModel,
            popularCreatorsByJob: popularCreatorsByJob,
            allCreatorsByJob: allCreatorsByJob
        )
    }
    
    private func convertSectionModel(from observable: Observable<[(String, [Creator])]>) -> Observable<[ExploreSectionModel]> {
        return observable.map { datas in
            datas.map { (jobCategory, creators) in
                return ExploreSectionModel(title: jobCategory, items: creators)
            }
        }
    }
}
