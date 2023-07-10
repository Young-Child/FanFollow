//
//  PostRepository.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/04.
//

import Foundation
import RxSwift

protocol PostRepository: SupabaseEndPoint {
    func fetchAllPost(startRange: Int, endRange: Int) -> Observable<[PostDTO]>
    func upsertPost(
        postID: String?, userID: String, createdDate: String,
        title: String, content: String, imageURLs: [String]?, videoURL: String?
    ) -> Completable
    func deletePost(postID: String) -> Completable
}
