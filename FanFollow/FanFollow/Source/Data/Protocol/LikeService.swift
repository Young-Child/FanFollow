//
//  LikeService.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/04.
//

import Foundation
import RxSwift

protocol LikeService {
    func fetchPostLike(id: String) -> Observable<[LikeDTO]>
}
