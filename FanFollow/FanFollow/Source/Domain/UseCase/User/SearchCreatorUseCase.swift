//
//  SearchCreatorUseCase.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/15.
//

import RxSwift

protocol SearchCreatorUseCase: AnyObject {
    func fetchSearchCreators(text: String?, startRange: Int, endRange: Int) -> Observable<[Creator]>
}

final class DefaultSearchCreatorUseCase: SearchCreatorUseCase {
    private let userInformationRepository: UserInformationRepository
    
    init(userInformationRepository: UserInformationRepository) {
        self.userInformationRepository = userInformationRepository
    }
    
    func fetchSearchCreators(
        text: String?,
        startRange: Int,
        endRange: Int
    ) -> Observable<[Creator]> {
        guard let text = text, text != "" else {
            return Observable.just([])
        }
        
        let searchList = userInformationRepository.fetchCreatorInformations(
            jobCategory: nil,
            nickName: text,
            startRange: startRange,
            endRange: endRange
        )
        
        return searchList
            .map { userInformationDTOList in
                userInformationDTOList.map { userInformationDTO in
                    return Creator(userInformationDTO)
                }
            }
    }
}
