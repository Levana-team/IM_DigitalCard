//
//  ConfigService.swift
//  IM_DigitalCard
//
//  Created by elie buff on 30/12/2020.
//

import Foundation
import Combine

class ConfigService{
    static let shared = ConfigService()
    private var disposables = Set<AnyCancellable>()
    
    func retrieveConfigValues() -> AnyPublisher<Bool, Never>{
        return NetworkingService.executeRequest(restMethod: .GET, wsName: "/setup?app=digitalCard", queryParams: nil, body: nil)
            .mapToDictionnary()
            .map{ response -> Bool in
                self.saveConfigItems(response: response)
                return true
            }
            .replaceError(with: true)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    private func saveConfigItems(response:[String: Any]){
        //self.parseAndSaveClientList(records: response, deleteAllNotIn: true)
         //self.cancellable?.cancel()
        
         /*
         if let picklists = response["picklists"] as? [[String : AnyObject]] {
             PickListObject.Upsert(picklists,
                                   in: childContext,
                                   deleteAllNotIn: true)
         }
         
         if let salesAssociates = response["SAs"] as? [[String : AnyObject]] {
             SalesAssociate.Upsert(salesAssociates,
                                   in: childContext,
                                   deleteAllNotIn: true)
         }
         */
        if let globalInfos = response["globalInfos"] as? [String : AnyObject] {
            for (k, v) in globalInfos{
                if let userDefaultKey = UserDefaultKey(rawValue: k){
                    UserDefaultUtils.saveItem(key: userDefaultKey, value: v)
                }
            }
        }
        
        
        if let documents = response["documents"] as? [[String : AnyObject]] {
            let context = CoreDataStack.shared.backgroundContext
            for document in documents{
                if let docId = document["docId"] as? String, let docExtension = document["docExtension"] as? String, let docName = document["docType"] as? String{
                    
                    if !Document.documentExists(context: context, docId: docId){
                        let _ = NetworkingService.getFileBody(fileId: docId).sink(receiveCompletion: {_ in}, receiveValue: {
                            
                            let _ = Document.addDocument(context: context, docId: docId, fileName: "\(docName).\(docExtension)", fileData: $0.asData(), docType: docName)
                        }).store(in: &disposables)
                    }
                }
            }
        }
        
        
         if let mappings = response["mappings"] as? [[String : AnyObject]] {
            CoreDataUtils.shared.saveToCoredata(data: mappings, type: [Mapping].self)
         }
        
        if let queries = response["queries"] as? [[String : AnyObject]] {
            CoreDataUtils.shared.saveToCoredata(data: queries, type: [Queries].self)
        }
         /*
         if let queries = response["queries"] as? [[String : AnyObject]] {
             Query.Upsert(queries,
                            deleteAllNotIn: true)
         }
         
         if let userInfos = response["userInfos"] as? [String : AnyObject] {
             for (k, v) in userInfos{
                 if let userDefaultKey = UserDefaultKey(rawValue: k){
                     UserDefaultUtils.saveItem(key: userDefaultKey, value: v)
                 }
             }
         //    UserUtils.getLocalUserInfo(loadLanguage: true)
         }
         
         if let todoTags = response["todoTags"] as? [[String : AnyObject]] {
             TodoTag.Upsert(todoTags,
                          deleteAllNotIn: true)
         }*/
    }
}
