//
//  ImageRepository.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import RxSwift

protocol ImageRepository: SupabaseEndPoint {
    func uploadImage(to path: String, with image: Data) -> Completable
    func updateImage(to path: String, with image: Data) -> Completable
    func deleteImage(to path: String) -> Completable
}
