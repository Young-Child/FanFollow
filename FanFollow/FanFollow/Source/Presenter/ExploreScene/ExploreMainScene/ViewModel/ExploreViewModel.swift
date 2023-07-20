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
        var viewByJopCategory: Observable<ExploreSectionItem>
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
        
        var jobAllcase = JobCategory.allCases
        jobAllcase.removeLast()
        
        let jobCategoryObservable = convertCategorySectionModel(from: Observable.just(jobAllcase))
        let exploreSectionModel = Observable.combineLatest(
            jobCategoryObservable, recommandAllCreatorsSectionModel
        ) { categories, recommand in
            return categories + recommand
        }
        
        // About viewByJopCategory Input
        input.viewByJopCategory
            .subscribe { sectionItem in
                switch sectionItem.element {
                case .category(let job):
                    print("JOB:", job)
                case .creator(let nickName, let userID):
                    print("CREATOR:", nickName, userID)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        return Output(exploreSectionModel: exploreSectionModel)
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
