//
//  ExploreSectionModel.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/17.
//

import RxSwift
import RxDataSources

struct ExploreSectionModel {
    var title: String
    var items: [Creator]
}

extension ExploreSectionModel: SectionModelType {
    typealias Item = Creator
    
    init(original: ExploreSectionModel, items: [Creator]) {
        self = original
        self.items = items
    }
}
