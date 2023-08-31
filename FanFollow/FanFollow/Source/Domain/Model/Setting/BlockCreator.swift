//
//  BlockCreator.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/31.
//

import Differentiator

struct BlockCreator {
    let creator: Creator
    var isBlock: Bool = true
}

extension BlockCreator: IdentifiableType {
    typealias Identity = String

    var identity: String {
        return creator.id
    }
}

extension BlockCreator: Equatable {
    static func == (lhs: BlockCreator, rhs: BlockCreator) -> Bool {
        return lhs.identity == rhs.identity && lhs.isBlock == rhs.isBlock
    }
}
