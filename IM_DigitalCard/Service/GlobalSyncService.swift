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
    
    
    func retrieveData() -> AnyPublisher<[Translation], Error>{
        return TranslationService.shared.getAllTranslations()
        //return ConfigService.shared.retrieveConfigValues()
        
    }
}
