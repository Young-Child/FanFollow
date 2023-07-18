//
//  ExploreSectionModel.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/17.
//

import RxSwift
import RxDataSources

struct ExploreSectionModel: AnimatableSectionModelType {
    typealias Identity = String
    
    var title: String
    var items: [ExploreSectionItem]
    
    var identity: String {
        return title
    }
    
    init(title: String, items: [ExploreSectionItem]) {
        self.title = title
        self.items = items
    }
    
    init(original: ExploreSectionModel, items: [ExploreSectionItem]) {
        self = original
        self.items = items
    }
}
