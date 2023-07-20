//
//  ExploreUseCase.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/12.
//

import RxSwift

protocol ExploreUseCase: AnyObject {
    func fetchRandomCreators(by jobCategory: JobCategory, count: Int) -> Observable<[Creator]>
    func fetchRandomCreatorsByAllCategory(count: Int) -> Observable<[(String, [Creator])]>
    func fetchPopularCreators(by jobCategory: JobCategory, count: Int) -> Observable<[Creator]>
}

final class DefaultExploreUseCase: ExploreUseCase {
    private let userInformationRepository: UserInformationRepository
    
    init(userInformationRepository: UserInformationRepository) {
        self.userInformationRepository = userInformationRepository
    }
    
    func fetchRandomCreators(by jobCategory: JobCategory, count: Int) -> Observable<[Creator]> {
        let creatorList = userInformationRepository.fetchRandomCreatorInformations(
            jobCategory: jobCategory,
            count: count
        )
        
        return creatorList.map { userInformationDTOList in
            userInformationDTOList.map { userInformationDTO in
                return Creator(userInformationDTO)
            }
        }
    }
    
    func fetchRandomCreatorsByAllCategory(count: Int) -> Observable<[(String, [Creator])]> {
        let allJobs = JobCategory.allCases
        
        let categoryCreatorsObservables = Observable.from(allJobs)
            .flatMap { category in
                return self.fetchRandomCreators(by: category, count: count)
                    .map { creators in
                        return (category.categoryName, creators)
                    }
            }
            .toArray()
            .asObservable()
        
        return categoryCreatorsObservables
    }
    
    func fetchPopularCreators(by jobCategory: JobCategory, count: Int) -> Observable<[Creator]> {
        let creatorList = userInformationRepository.fetchPopularCreatorInformations(
            jobCategory: jobCategory,
            count: count
        )
        
        return creatorList.map { userInformationDTOList in
            userInformationDTOList.map { userInformationDTO in
                return Creator(userInformationDTO)
            }
        }       
    }
    
    
}
