//
//  TranslationService.swift
//  IM_DigitalCard
//
//  Created by elie buff on 29/12/2020.
//

import Combine
import SalesforceSDKCore
import CoreData

class TranslationService{
    static let shared = TranslationService()
    var cancellable: Cancellable?
    
    func getAllTranslations() -> AnyPublisher<RestResponse, Error>{
        
        let decoder = JSONDecoder()
        let currentContext = CoreDataStack.shared.backgroundContext
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = currentContext
        
        Translation.emptyEntity()
        return NetworkingService.executeRequest(restMethod: .GET, wsName: "/translation?app=digitalCard")
            .receive(on: RunLoop.main)
            .saveToCoreData(type: [Translation].self)
            .eraseToAnyPublisher()
    }
}
