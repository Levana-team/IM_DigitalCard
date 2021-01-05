//
//  Publisher + mapToList.swift
//  IM_DigitalCard
//
//  Created by elie buff on 29/12/2020.
//

import Combine
import SalesforceSDKCore

extension Publisher where Output == RestResponse{
  func mapToList()
    -> Publishers.Map<Self, [[String : AnyObject]]>{
        map{
            do {
                let responseData = try $0.asJson()
                if let respoonseData = responseData as? [[String : AnyObject]]{
                    return respoonseData
                }
                return []
            } catch {
                fatalError("Failed to fetch tasks:")
            }
            
        }
    }
}

extension Publisher where Output == RestResponse{
  func mapToDictionnary()
    -> Publishers.Map<Self, [String : Any]>{
        map{
            do {
                let responseData = try $0.asJson()
                if let responseData = responseData as? [String : Any]{
                    return responseData
                }
                return [String: Any]()
            } catch {
                fatalError("Failed to fetch tasks:")
            }
            
        }
    }
}

extension Publisher where Output == RestResponse{
    func saveDocument(docId: String, fileName: String)
    -> Publishers.Map<Self, Void>{
        map{
            let responseData =  $0.asData()
            let _ = FileManagement.sharedInstance.createFile(fileData: responseData, fileName: fileName)
        }
    }
}

extension Publisher where Output == RestResponse{
    func saveToCoreData<T: Codable>()
    -> Publishers.TryMap<Self, T>{
        tryMap{ result -> T in
            
            let decoder = JSONDecoder()
            let currentContext = CoreDataStack.shared.backgroundContext
            decoder.userInfo[CodingUserInfoKey.managedObjectContext] = currentContext
            
            let value = try decoder.decode(T.self, from: result.asData())
            CoreDataStack.shared.save(context: currentContext)
            
            return value
        }
    }
}
