//
//  PokeMyFriendsCoordinator.swift
//  PokeFeature
//
//  Created by sejin on 12/14/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import Domain
import BaseFeatureDependency
import PokeFeatureInterface

public
final class PokeMyFriendsCoordinator: DefaultCoordinator {
    public var finishFlow: (() -> Void)?
    
    private let factory: PokeFeatureBuildable
    private let router: Router
    
    public init(factory: PokeFeatureBuildable, router: Router) {
        self.factory = factory
        self.router = router
    }
    
    public override func start() {
        showPokeMyFriends()
    }
    
    private func showPokeMyFriends() {
        var pokeMyFriends = factory.makePokeMyFriends()
        
        pokeMyFriends.vm.showFriendsListButtonTap = { [weak self] relation in
            self?.showPokeMyFriendsList(with: relation)
        }
        
        router.push(pokeMyFriends.vc)
    }
    
    private func showPokeMyFriendsList(with relation: PokeRelation) {
        var pokeMyFriendsList = factory.makePokeMyFriendsList(relation: relation)
        
        pokeMyFriendsList.vm.onCloseButtonTap = { [weak self] in 
            self?.router.dismissModule(animated: true)
        }
        
        pokeMyFriendsList.vm.onPokeButtonTapped = { [weak self] userModel in
            guard let bottomSheet = self?.factory
                .makePokeMessageTemplateBottomSheet(messageType: .pokeFriend)
                    .vc
                    .viewController as? PokeMessageTemplateBottomSheet
            else { return .empty() }
            
            let bottomSheetManager = BottomSheetManager(configuration: .messageTemplate())
            
            self?.router.showBottomSheet(manager: bottomSheetManager, 
                                         toPresent: bottomSheet,
                                         on: pokeMyFriendsList.vc.viewController)
            
            return bottomSheet
                .signalForClick()
                .map { (userModel, $0) }
                .asDriver()
        }
        
        router.present(pokeMyFriendsList.vc, animated: true)
    }
}
