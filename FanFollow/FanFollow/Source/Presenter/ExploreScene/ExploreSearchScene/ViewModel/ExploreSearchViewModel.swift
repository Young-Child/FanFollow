//
//  ExploreSearchViewModel.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/23.
//

import RxSwift
import RxCocoa

final class ExploreSearchViewModel: ViewModel {
    struct Input {
        var textDidSearch: Observable<String?>
        var viewDidScroll: Observable<Void>
    }
    
    struct Output {
        var searchCreatorResultModel: Observable<[Creator]>
    }
    
    enum Action {
        case load([Creator])
        case loadMore([Creator])
    }
    
    var disposeBag = DisposeBag()
    private let searchCreatorUseCase: SearchCreatorUseCase
    
    // Pagination Properties
    private let pageCount = BehaviorRelay<Int>(value: .zero)
    
    init(searchCreatorUseCase: SearchCreatorUseCase) {
        self.searchCreatorUseCase = searchCreatorUseCase
    }
    
    func transform(input: Input) -> Output {
        let loadObservable = input.textDidSearch
            .do(onNext: { text in
                self.pageCount.accept(.zero)
            })
            .flatMap { text in
                guard let searchText = text, !searchText.isEmpty else {
                    return Observable<[Creator]>.just([])
                }
                return self.searchCreatorUseCase.fetchSearchCreators(
                    text: text ?? "",
                    startRange: 0,
                    endRange: 20
                )
            }
        
        let loadMoreObservable = input.viewDidScroll
            .withLatestFrom(input.textDidSearch)
            .compactMap { $0 }
            .flatMap { text in
                guard !text.isEmpty else {
                    return Observable<[Creator]>.just([])
                }
                guard self.pageCount.value >= 20 else {
                    return Observable<[Creator]>.empty()
                }
                
                return self.searchCreatorUseCase.fetchSearchCreators(
                    text: text,
                    startRange: self.pageCount.value,
                    endRange: self.pageCount.value + 20
                )
            }

        let loadMap: Observable<Action> = loadObservable
              .map { Action.load($0) }

        let loadMoreMap: Observable<Action> = loadMoreObservable
              .map { Action.loadMore($0) }
        
        
        let creatorResult: Observable<[Creator]> =
          Observable.merge(loadMap, loadMoreMap)
            .scan(into: [Creator]()) { creators, action in
              switch action {
              case .load(let newCreators):
                  creators = newCreators
                  self.pageCount.accept(creators.count)
              case .loadMore(let newCreators):
                  creators += newCreators
                  self.pageCount.accept(creators.count)
              }
        }
        
        return Output(searchCreatorResultModel: creatorResult)
    }
}
