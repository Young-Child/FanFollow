//
//  SearchCreatorUseCase.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/15.
//

import RxSwift

protocol SearchCreatorUseCase: AnyObject {
    func fetchSearchCreators(
        text: String,
        jobCategory: JobCategory,
        startRange: Int,
        endRange: Int
    ) -> Observable<[Creator]>
}

final class DefaultSearchCreatorUseCase: SearchCreatorUseCase {
    private let userInformationRepository: UserInformationRepository
    
    init(userInformationRepository: UserInformationRepository) {
        self.userInformationRepository = userInformationRepository
    }
    
    func fetchSearchCreators(
        text: String,
        jobCategory: JobCategory,
        startRange: Int,
        endRange: Int
    ) -> Observable<[Creator]> {
        let searchList = userInformationRepository.fetchCreatorInformations(
            jobCategory: jobCategory.rawValue,
            nickName: text,
            startRange: startRange,
            endRange: endRange
        )
        
        return searchList
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .map { userInformationDTOList in
                userInformationDTOList.map { userInformationDTO in
                    return Creator(userInformationDTO)
                }
            }
    }
}
