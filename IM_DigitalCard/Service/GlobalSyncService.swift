//
//  GlobalSyncService.swift
//  IM_DigitalCard
//
//  Created by elie buff on 29/12/2020.
//

import Combine
import CoreData
import SalesforceSDKCore


class GlobalSyncService{
    static let shared = GlobalSyncService()
    private var disposables = Set<AnyCancellable>()
    
    
    func needToPerformSync() -> Bool{
        if let isDev = Utils.getPlistValue(for: "IsDev") as? Bool, isDev{
            return true
        }
           
        guard let lastUpdate =  UserDefaultUtils.getItem(key: .lastUpdate) as? Date else{
            return true
        }
       
        if !NSCalendar.current.isDateInToday(lastUpdate){
            return true
        }
        
        return false
    }
    
    
    func retrieveData() -> AnyPublisher<Bool, Never>{
        func retrieveInnerData() -> AnyPublisher<Bool, Never>{
            let pubs = [
                TranslationService.shared.getAllTranslations().map{ _ in  true}.replaceError(with: true).eraseToAnyPublisher(),
                ClientService.shared.getMyStoreClients().map{ _ in  true}.replaceError(with: true).eraseToAnyPublisher(),
                ClientListService.shared.getClientList().map{ _ in  true}.replaceError(with: true).eraseToAnyPublisher()
            ]
            return pubs.publisher.flatMap{ $0 }.collect().map{ _ in  true}.eraseToAnyPublisher()
        }
        
        return ConfigService.shared.retrieveConfigValues()
            .flatMap{ _ in
                return retrieveInnerData()
        }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
