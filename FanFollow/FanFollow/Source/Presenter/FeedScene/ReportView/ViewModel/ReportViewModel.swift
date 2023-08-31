//
//  ReportViewModel.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/31.
//

import RxSwift

final class ReportViewModel: ViewModel {
    struct Input {
        var didTapReportButton: Observable<Int>
    }

    struct Output {
        var result: Observable<Bool>
    }

    var disposeBag = DisposeBag()
    private let banID: String
    private let sendReportUseCase: SendReportUseCase
    
    init(sendReportUseCase: SendReportUseCase, banID: String) {
        self.sendReportUseCase = sendReportUseCase
        self.banID = banID
    }

    func transform(input: Input) -> Output {
        let reportResult = input.didTapReportButton
            .flatMap { reasonIndex in
                return self.sendReportUseCase.reportOrBlock(
                    banID: self.banID,
                    reasonIndex: reasonIndex
                )
                .andThen(Observable.just(true))
            }
        
        return Output(result: reportResult)
    }
}
