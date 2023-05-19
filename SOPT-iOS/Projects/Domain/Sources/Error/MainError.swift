//
//  MainError.swift
//  Core
//
//  Created by sejin on 2023/04/29.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public enum MainError: Error {
    case networkError(message: String?)
    case unregisteredUser // 플그 미동록 유저
    case authFailed // 토큰 재발급 실패 등 인증 에러
}

extension MainError: CustomNSError {
    public var errorUserInfo: [String : Any] {
        func getDebugDescription() -> String {
            switch self {
            case .networkError(let message):
                return  message ?? ""
            case .unregisteredUser:
                return "플그 미등록"
            case .authFailed:
                return "인증 실패"
            }
        }

        return [NSDebugDescriptionErrorKey: getDebugDescription()]
    }
}