//
//  ImageRepository.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import RxSwift

protocol ImageRepository: AnyObject {
    func uploadImage(to imageName: String, with image: Data) -> Completable
    func updateImage(to imageName: String, with image: Data) -> Completable
    func deleteImage(to path: String) -> Completable
}
