//
//  AuthFeatureViewControllable.swift
//  AuthFeatureInterface
//
//  Created by 김영인 on 2023/03/17.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency

public protocol SignInViewControllable: ViewControllable { }

public protocol AuthFeatureViewBuildable {
    func makeSignInVC() -> SignInViewControllable
}
