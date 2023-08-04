//
//  CreatorApplicationViewModel.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/31.
//

import RxSwift
import RxRelay

final class CreatorApplicationViewModel: ViewModel {
    struct Input {
        var viewWillAppear: Observable<Void>
        var backButtonTap: Observable<Void>
        var nextButtonTap: Observable<CreatorInformation>
    }

    struct Output {
        var creatorApplicationStep: Observable<CreatorApplicationStep>
    }

    typealias CreatorInformation = (category: Int?, links: [String]?, introduce: String?)

    var disposeBag = DisposeBag()
    private let applyCreatorUseCase: ApplyCreatorUseCase
    private let userID: String
    private let creatorApplicationStep = BehaviorRelay(value: CreatorApplicationStep.category)

    init(applyCreatorUseCase: ApplyCreatorUseCase, userID: String) {
        self.applyCreatorUseCase = applyCreatorUseCase
        self.userID = userID
    }

    func transform(input: Input) -> Output {
        let initialStep = input.viewWillAppear
            .withUnretained(self)
            .flatMapFirst { _ -> Observable<CreatorApplicationStep> in
                return .just(self.creatorApplicationStep.value)
            }

        let nextStep = input.nextButtonTap
            .withUnretained(self)
            .flatMapFirst { _, creatorInformation -> Observable<CreatorApplicationStep> in
                let currentStep = self.creatorApplicationStep.value
                let nextStep = currentStep.next
                switch currentStep {
                case .introduce:
                    return self.registerCreatorInformation(creatorInformation).andThen(Observable.just(nextStep))
                default:
                    return .just(nextStep)
                }
            }

        let previousStep = input.backButtonTap
            .withUnretained(self)
            .flatMapFirst { _ -> Observable<CreatorApplicationStep> in
                let currentStep = self.creatorApplicationStep.value
                let previousStep = currentStep.previous
                return .just(previousStep)
            }

        let creatorApplicationStep = Observable.merge(initialStep, nextStep, previousStep)
            .do { step in
                self.creatorApplicationStep.accept(step)
            }

        return Output(creatorApplicationStep: creatorApplicationStep)
    }
}

private extension CreatorApplicationViewModel {
    func registerCreatorInformation(_ creatorInformation: CreatorInformation) -> Completable {
        return self.applyCreatorUseCase.applyCreator(
            userID: self.userID,
            creatorInformation: (
                creatorInformation.category,
                creatorInformation.links,
                creatorInformation.introduce
            )
        )
    }
}

private extension CreatorApplicationStep {
    var next: Self {
        switch self {
        case .back:
            return .category
        case .category:
            return .links
        case .links:
            return .introduce
        case .introduce:
            return .back
        }
    }

    var previous: Self {
        switch self {
        case .back:
            return .back
        case .category:
            return .back
        case .links:
            return .category
        case .introduce:
            return .links
        }
    }
}
