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
            .flatMapLatest { text in
                guard let searchText = text, !searchText.isEmpty else {
                    return Observable<[Creator]>.just([])
                }
                return self.searchCreatorUseCase.fetchSearchCreators(
                    text: text ?? "",
                    startRange: .zero,
                    endRange: Constants.pageUnit
                )
            }
        
        let loadMoreObservable = input.viewDidScroll
            .withLatestFrom(input.textDidSearch)
            .compactMap { $0 }
            .flatMapLatest { text in
                guard !text.isEmpty else {
                    return Observable<[Creator]>.just([])
                }
                
                return self.searchCreatorUseCase.fetchSearchCreators(
                    text: text,
                    startRange: self.pageCount.value + 1,
                    endRange: self.pageCount.value + Constants.pageUnit
                )
            }
        
        let loadActionObservable = loadObservable
            .map { Action.load($0) }
        
        let loadMoreActionObservable = loadMoreObservable
            .map { Action.loadMore($0) }
        
        let creatorResult = Observable.merge(loadActionObservable, loadMoreActionObservable)
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

private extension ExploreSearchViewModel {
    enum Constants {
        static let pageUnit = 20
    }
}
