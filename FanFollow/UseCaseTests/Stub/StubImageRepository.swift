//
//  StubImageRepository.swift
//  UseCaseTests
//
//  Created by parkhyo on 2023/08/06.
//

import Foundation

import RxSwift

@testable import FanFollow

final class StubImageRepository: ImageRepository {
    var error: Error?
    
    func uploadImage(to path: String, with image: Data) -> Completable {
        return Completable.create { observer in
            if let error = self.error {
                observer(.error(error))
            } else {
                observer(.completed)
            }
            return Disposables.create()
        }
    }
    
    func updateImage(to path: String, with image: Data) -> Completable {
        return Completable.create { observer in
            if let error = self.error {
                observer(.error(error))
            } else {
                observer(.completed)
            }
            return Disposables.create()
        }
    }
    
    func deleteImage(to path: String) -> Completable {
        return Completable.create { observer in
            if let error = self.error {
                observer(.error(error))
            } else {
                observer(.completed)
            }
            return Disposables.create()
        }
    }
    
    func readImageList(to path: String, keyword: String) -> Observable<[SupabaseImageResource]> {
        let data = SupabaseImageResource(name: path + keyword)
        
        return Observable.just([data])
    }
}
