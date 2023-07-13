//
//  ExploreUseCase.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/12.
//

import Foundation
import RxSwift

protocol ExploreUseCase: AnyObject {
    func fetchRandomCreators(jobCategory: JobCategory) -> Observable<[Creator]>
    func fetchRandomAllCreators() -> Observable<[String: [Creator]]>
}

final class DefaultExploreUseCase: ExploreUseCase {
    private let userInformationRepository: UserInformationRepository
    
    init(userInformationRepository: UserInformationRepository) {
        self.userInformationRepository = userInformationRepository
    }
    
    func fetchRandomCreators(jobCategory: JobCategory) -> Observable<[Creator]> {
        let creatorList = userInformationRepository.fetchRandomCreatorInformations(jobCategory: jobCategory)
        
        return creatorList.map { userInformationDTOList in
            userInformationDTOList.map { userInformationDTO in
                return Creator(userInformationDTO)
            }
        }
    }
    
    func fetchRandomAllCreators() -> Observable<[String: [Creator]]> {
        var categoryCreator: [String: [Creator]] = [:]
        let allJobs = JobCategory.allCases
        
        let fetchCreatorsObservables = allJobs.map { jobCategory in
            return fetchRandomCreators(jobCategory: jobCategory)
                .map { creators in
                    return (jobCategory, creators)
                }
        }
        
        return Observable.zip(fetchCreatorsObservables)
            .map { results in
                for (jobCategory, creators) in results {
                    categoryCreator[jobCategory.categoryName] = creators
                }
                return categoryCreator
            }
    }
}
