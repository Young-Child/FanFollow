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
        var categoryChanged: Observable<JobCategory>
        var linksChanged: Observable<[String]>
        var introduceChanged: Observable<String>
        var backButtonTap: Observable<Void>
        var nextButtonTap: Observable<Void>
    }

    struct Output {
        var creatorApplicationStep: Observable<CreatorApplicationStep>
        var creatorInformation: Observable<CreatorInformation>
    }

    typealias CreatorInformation = (category: JobCategory?, links: [String]?, introduce: String?)

    var disposeBag = DisposeBag()
    private let creatorApplicationUseCase: ApplyCreatorUseCase
    private let userID: String
    private let creatorInformation = BehaviorRelay<CreatorInformation>(value:(nil, nil, nil))
    private let creatorApplicationStep = BehaviorRelay(value: CreatorApplicationStep.category)

    init(creatorApplicationUseCase: ApplyCreatorUseCase, userID: String) {
        self.creatorApplicationUseCase = creatorApplicationUseCase
        self.userID = userID
    }

    func transform(input: Input) -> Output {
        let initialStep = input.viewWillAppear
            .withUnretained(self)
            .flatMapLatest { _ -> Observable<CreatorApplicationStep> in
                return self.creatorApplicationStep.asObservable()
            }

        let nextStep = input.nextButtonTap
            .withUnretained(self)
            .flatMapLatest { _ -> Observable<CreatorApplicationStep> in
                let currentStep = self.creatorApplicationStep.value
                let nextStep = currentStep.next
                switch currentStep {
                case .introduce:
                    return self.registerCreatorInformation().andThen(Observable.just(nextStep))
                default:
                    return .just(nextStep)
                }
            }

        let previousStep = input.backButtonTap
            .withUnretained(self)
            .flatMapLatest { _ -> Observable<CreatorApplicationStep> in
                let currentStep = self.creatorApplicationStep.value
                let previousStep = currentStep.previous
                return .just(previousStep)
            }

        let creatorApplicationStep = Observable.merge(initialStep, nextStep, previousStep)
            .do { step in
                self.creatorApplicationStep.accept(step)
            }

        let initialCreatorInformation = input.viewWillAppear
            .withUnretained(self)
            .flatMapLatest { _ -> Observable<CreatorInformation> in
                return .just((category: .art, links: [], introduce: nil))
            }

        let updatedCreatorInformation = Observable.merge(
            input.categoryChanged.map { category -> CreatorInformation in (category, nil, nil) },
            input.linksChanged.map { links -> CreatorInformation in (nil, links, nil) },
            input.introduceChanged.map { introduce -> CreatorInformation in (nil, nil, introduce) }
        )
            .withUnretained(self)
            .flatMapLatest { _, updatedCreatorInformation in
                return self.updatedCreatorInformation(updatedCreatorInformation)
            }

        let creatorInformation = Observable.merge(initialCreatorInformation, updatedCreatorInformation)
            .do { creatorInformation in
                self.creatorInformation.accept(creatorInformation)
            }

        return Output(creatorApplicationStep: creatorApplicationStep, creatorInformation: creatorInformation)
    }
}

private extension CreatorApplicationViewModel {
    func registerCreatorInformation() -> Completable {
        let creatorInformation = self.creatorInformation.value
        return self.creatorApplicationUseCase.applyCreator(
            userID: self.userID,
            creatorInformation: (
                creatorInformation.category?.rawValue,
                creatorInformation.links,
                creatorInformation.introduce
            )
        )
    }

    func updatedCreatorInformation(_ creatorInformation: CreatorInformation) -> Observable<CreatorInformation> {
        var creatorInformation = self.creatorInformation.value
        if let category = creatorInformation.category {
            creatorInformation.category = category
        }
        if let links = creatorInformation.links {
            creatorInformation.links = links
        }
        if let introduce = creatorInformation.introduce {
            creatorInformation.introduce = introduce
        }
        return .just(creatorInformation)
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
