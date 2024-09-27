//
//  DailySoptuneMainViewModel.swift
//  DailySoptuneFeatureInterface
//
//  Created by 강윤서 on 9/26/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain

import DailySoptuneFeatureInterface

public final class DailySoptuneMainViewModel: DailySoptuneMainViewModelType {
    
    public var onNavibackTap: (() -> Void)?
    public var onReciveTodayFortuneButtonTap: (() -> Void)?
	
	// MARK: - Properties

    private let useCase: DailySoptuneUseCase
	private var cancelBag = CancelBag()
	
	// MARK: - Inputs
	
	public struct Input {
        let viewDidLoad: Driver<Void>
        let naviBackButtonTap: Driver<Void>
        let receiveTodayFortuneButtonTap: Driver<Void>
	}
	
	// MARK: - Outputs
	
	public struct Output {
        let todayFortuneResult = PassthroughSubject<DailySoptuneResultModel, Never>()
	}
	
	// MARK: - Initialization
	
    public init(useCase: DailySoptuneUseCase) {
        self.useCase = useCase
    }
}

extension DailySoptuneMainViewModel {
	public func transform(from input: Input, cancelBag: CancelBag) -> Output {
		let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.viewDidLoad
            .withUnretained(self)
            .sink {_ in
                self.onNavibackTap?()
            }.store(in: cancelBag)
        
        input.receiveTodayFortuneButtonTap
            .withUnretained(self)
            .sink { _ in
                self.onReciveTodayFortuneButtonTap?()
                self.useCase.getDailySoptuneResult(date: "2024-09-19")
            }.store(in: cancelBag)
        
		return output
	}
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        useCase.dailySoptuneResult
            .asDriver()
            .subscribe(output.todayFortuneResult)
            .store(in: cancelBag)
    }
}
