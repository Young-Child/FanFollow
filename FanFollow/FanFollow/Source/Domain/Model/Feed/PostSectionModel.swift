//
//  PostSectionModel.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxDataSources

struct PostSectionModel: AnimatableSectionModelType {
    typealias Identity = String
    
    var title: String
    var items: [Post]
    
    var identity: String {
        return title
    }
    
    init(title: String, items: [Post]) {
        self.title = title
        self.items = items
    }
    
    init(original: PostSectionModel, items: [Post]) {
        self = original
        self.items = items
    }
}
