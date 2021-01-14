//
//  ClientService.swift
//  IM_DigitalCard
//
//  Created by elie buff on 02/01/2021.
//

import Foundation
import Combine

class ClientService{
    static let shared = ClientService()
    private var disposables = Set<AnyCancellable>()
    
    func getMyStoreClients() -> AnyPublisher<Bool, Never>{
        let clientMapping = Mapping.fetchEntityMapping(context: CoreDataStack.shared.backgroundContext, entityMappingNames: ["Account"]) 
        
        return NetworkingService.SOQLExecuter(query: "SELECT Id, Name from Account", mapping: clientMapping, [Account].self)
    }
    
    func checkDuplicate(clientItem: Client) -> AnyPublisher<Bool, Never>{
        NetworkingService.executeRequestDecodable(restMethod: .POST, wsName: "/client/checkDuplicate", queryParams: nil, body: clientItem)!
            .mapToDictionnary()
            .map{ response -> Bool in
                if let isDuplicate = response["isDuplicate"] as? Bool {
                    return isDuplicate
                }
                return true
            }
            .replaceError(with: false)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func saveNewClient(clientItem: Client) -> AnyPublisher<Client, Error> {
        NetworkingService.executeRequestDecodable(restMethod: .POST, wsName: "/client", queryParams: nil, body: clientItem)!
            .receive(on: RunLoop.main)
            .tryMap { result -> Client in
    
                let decoder = JSONDecoder()
                let currentContext = CoreDataStack.shared.backgroundContext
                decoder.userInfo[CodingUserInfoKey.managedObjectContext] = currentContext
                
                
        let value = try decoder.decode(Client.self, from: result.asData())
        CoreDataStack.shared.save(context: currentContext)
        
        return value
    }
            .eraseToAnyPublisher()
    }
}
