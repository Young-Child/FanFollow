//
//  ReportViewModel.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/31.
//

import RxSwift

final class ReportViewModel: ViewModel {
    struct Input {
        var didTapReportButton: Observable<(isContent: Bool, reasonIndex: Int)>
    }

    struct Output {
        var result: Observable<Bool>
    }

    var disposeBag = DisposeBag()
    private let banID: String
    private let reportUseCase: SendReportUseCase
    private let blockContentUseCase: BlockContentUseCase
    
    init(
        reportUseCase: SendReportUseCase,
        blockContentUseCase: BlockContentUseCase,
        banID: String
    ) {
        self.reportUseCase = reportUseCase
        self.blockContentUseCase = blockContentUseCase
        self.banID = banID
    }

    func transform(input: Input) -> Output {
        let reportResult = input.didTapReportButton
            .flatMap { (isContent, reasonIndex) in
                if reasonIndex == 0 && isContent {
                    return self.blockContentUseCase.block(postID: self.banID)
                        .andThen(Observable<Bool>.just(true))
                }
                
                let reasons = ReportReason.reasons(
                    reportType: isContent ? ReportType.content : ReportType.user
                )
                let reason = reasons[reasonIndex].reason
                
                let blockObservable = self.blockContentUseCase.block(postID: self.banID)    
                let reportObservable = self.reportUseCase.sendReport(
                    banPostID: self.banID,
                    isContent: isContent,
                    reason: reason
                )
                    
                return Completable.concat(blockObservable, reportObservable)
                    .andThen(Observable<Bool>.just(true))
            }
        
        return Output(result: reportResult)
    }
}
