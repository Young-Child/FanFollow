//
//  ExploreSubscribeViewModel.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/28.
//

import RxRelay
import RxSwift

final class ExploreSubscribeViewModel: ViewModel {
    struct Input {
        var viewWillAppear: Observable<Void>
        var viewDidScroll: Observable<Void>
    }
    
    struct Output {
        var creatorListModel: Observable<[Creator]>
    }
    
    enum Action {
        case load([Creator])
        case loadMore([Creator])
    }
    
    var disposeBag = DisposeBag()
    private let fetchCreatorUseCase: FetchCreatorInformationUseCase
    private let userID: String
    
    // Pagination Property
    private let pageCount = BehaviorRelay<Int>(value: .zero)
    
    init(userID: String, fetchCreatorUseCase: FetchCreatorInformationUseCase) {
        self.userID = userID
        self.fetchCreatorUseCase = fetchCreatorUseCase
    }
    
    func transform(input: Input) -> Output {
        let loadObservable = input.viewWillAppear
            .flatMapLatest {
                return self.fetchCreatorUseCase.fetchFollowings(
                    for: self.userID,
                    startRange: .zero,
                    endRange: Constants.pageUnit
                )
            }
        
        let loadMoreObservable = input.viewDidScroll
            .flatMapLatest {
                return self.fetchCreatorUseCase.fetchFollowings(
                    for: self.userID,
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
        
        return Output(creatorListModel: creatorResult)
    }
}

private extension ExploreSubscribeViewModel {
    enum Constants {
        static let pageUnit = 20
    }
}
