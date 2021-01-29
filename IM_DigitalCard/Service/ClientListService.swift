//
//  ClientListService.swift
//  IM_DigitalCard
//
//  Created by Elie Buff on 16/01/2021.
//

import Combine
import SalesforceSDKCore
import CoreData

class ClientListService{
    static let shared = ClientListService()
    var disposables = Set<AnyCancellable>()
    
    func getClientList() -> AnyPublisher<Bool, Error>{
        return NetworkingService.executeRequest(restMethod: .GET, wsName: "/clientList")
            .saveToCoreData(type: [ClientList].self)
            .flatMap{ _ in
                return self.retrieveClientListItems()
            }.eraseToAnyPublisher()
    }
    
    func retrieveClientListItems() -> AnyPublisher<Bool, Never>{
        let clientMapping = Mapping.fetchEntityMapping(context: CoreDataStack.shared.backgroundContext, entityMappingNames: ["Account"])
        let clientLists = ClientList.getRecords() as! [ClientList]
        
        var pubs = [AnyPublisher<Bool, Never>]()
        for clientList in clientLists{
            let query = SOQLQueries.getClientListItems(clientListItem: clientList)
            
            pubs.append(
                NetworkingService.SOQLExecuter(query: query, mapping: clientMapping, Set<Account>.self){ (clients, context) in
                    let clientList = context.object(with: clientList.objectID) as! ClientList
                    clientList.clients = clients as NSSet
                }
            )
        }
        return pubs.publisher.flatMap{ $0 }.collect().map{ _ in  true}.eraseToAnyPublisher()
    }
}
