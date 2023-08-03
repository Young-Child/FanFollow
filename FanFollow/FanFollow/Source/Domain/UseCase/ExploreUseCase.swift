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
    func fetchCreators(by jobCategory: JobCategory, startRange: Int, endRange: Int) -> Observable<[Creator]>
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
        // TODO: - Test를 위해서 임의로 데이터를 조작함.
        // 추후 변경 필수
        let allJobs = JobCategory.allCases.filter { $0 != .unSetting }
        
        let categoryCreatorsObservables = Observable.from(allJobs)
            .flatMap { category in
                return self.fetchRandomCreators(by: JobCategory.art, count: count)
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
    
    func fetchCreators(by jobCategory: JobCategory, startRange: Int, endRange: Int) -> Observable<[Creator]> {
        let creatorList = userInformationRepository.fetchCreatorInformations(
            jobCategory: jobCategory.rawValue,
            nickName: nil,
            startRange: startRange,
            endRange: endRange
        )
        
        return creatorList.map { userInformationDTOList in
            userInformationDTOList.map { userInformationDTO in
                return Creator(userInformationDTO)
            }
        }
    }
}
