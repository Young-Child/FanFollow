//
//  ImageRepository.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import RxSwift

protocol ImageRepository: SupabaseEndPoint {
    func readImage(to path: String) -> Observable<Data>
    func uploadImage(to path: String, with image: Data) -> Completable
    func updateImage(to path: String, with image: Data) -> Completable
    func deleteImage(to path: String) -> Completable
    func readImageList(to path: String, keyword: String) -> Observable<[SupabaseImageResource]>
}
