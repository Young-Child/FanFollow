//
//  BlockCreatorManagementViewModel.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/31.
//

import Foundation

import RxSwift
import RxRelay

final class BlockCreatorManagementViewModel: ViewModel {
    struct Input {
        var viewWillAppear: Observable<Void>
        var blockToggleButtonTap: Observable<String>
    }

    struct Output {
        var blockCreators: Observable<[BlockCreatorSectionModel]>
    }

    var disposeBag = DisposeBag()
    private let manageBlockCreatorUseCase: ManageBlockCreatorUseCase

    private let blockCreators = BehaviorRelay<[BlockCreator]>(value: [])

    init(manageBlockCreatorUseCase: ManageBlockCreatorUseCase) {
        self.manageBlockCreatorUseCase = manageBlockCreatorUseCase
    }

    func transform(input: Input) -> Output {
        let fetchedBlockCreators = input.viewWillAppear
            .withUnretained(self)
            .flatMapLatest { _ in
                return self.manageBlockCreatorUseCase.fetchBlockCreators()
            }
            .map { creators in creators.map { creator in BlockCreator(creator: creator) } }

        let updatedBlockCreators = input.blockToggleButtonTap
            .withUnretained(self)
            .flatMapLatest { _, banID -> Observable<BlockCreator> in
                guard let blockCreator = self.blockCreator(for: banID) else { return .empty() }
                if blockCreator.isBlock {
                    return self.manageBlockCreatorUseCase.resolveBlockCreator(to: banID)
                        .andThen(.just(blockCreator))
                } else {
                    return self.manageBlockCreatorUseCase.blockCreator(to: banID)
                        .andThen(.just(blockCreator))
                }
            }
            .map { blockCreator in
                var blockCreator = blockCreator
                blockCreator.isBlock = !blockCreator.isBlock
                return self.updatedBlockCreators(blockCreator: blockCreator)
            }

        let blockCreators = Observable.merge(fetchedBlockCreators, updatedBlockCreators)
            .do { blockCreators in
                self.blockCreators.accept(blockCreators)
            }
            .map { blockCreators in
                return [
                    BlockCreatorSectionModel(title: UUID().uuidString, items: blockCreators)
                ]
            }

        return Output(blockCreators: blockCreators)
    }

    private func blockCreator(for id: String) -> BlockCreator? {
        return blockCreators.value.first(where: { $0.identity == id })
    }

    private func updatedBlockCreators(blockCreator: BlockCreator) -> [BlockCreator] {
        var blockCreators = self.blockCreators.value
        guard let firstIndex = blockCreators.firstIndex(where: {
            $0.identity == blockCreator.identity
        }) else { return blockCreators }
        blockCreators[firstIndex] = blockCreator
        return blockCreators
    }
}
