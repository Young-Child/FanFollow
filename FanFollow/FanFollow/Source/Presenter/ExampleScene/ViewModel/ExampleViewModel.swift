//
//  ExampleViewModel.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

//import RxSwift
//import RxCocoa
//
//final class ExampleViewModel: ViewModel {
//    struct Input {
//        var didTapButton: Driver<Void>
//        var viewWillAppear: Observable<Void>
//    }
//
//    struct Output {
//        var fetchedUsers: Observable<ExampleModel>
//    }
//
//    var useCase: ExampleUseCase
//
//    init(useCase: ExampleUseCase) {
//        self.useCase = useCase
//    }
//
//    func transform(input: Input) -> Output {
//        let fetchedUsers = Observable.combineLatest(input.didTapButton, input.viewWillAppear)
//            .asObservable()
//            .flatMap { return useCase.fetchUserInformation() }
//
//        return Output(
//            fetchedUsers: fetchedUsers
//        )
//    }
//}
