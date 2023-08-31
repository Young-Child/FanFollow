//
//  BlockCreatorSectionModel.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/31.
//

import RxDataSources

struct BlockCreatorSectionModel: AnimatableSectionModelType {
    typealias Item = BlockCreator
    typealias Identity = String

    var title: String
    var items: [BlockCreator]

    var identity: String {
        return title
    }

    init(title: String, items: [BlockCreator]) {
        self.title = title
        self.items = items
    }

    init(original: BlockCreatorSectionModel, items: [BlockCreator]) {
        self = original
        self.items = items
    }
}
