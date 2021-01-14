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


extension Publisher where Output == RestResponse{
    func saveToCoreData<T: Codable>(mapping: [String: String], type: T.Type)
    -> Publishers.Map<Self, RestResponse>{
        map{ result -> RestResponse in
            do {
                let jsonData = try result.asJson()
                if let responseData = jsonData as? [String : Any]{
                    if let records = responseData["records"] as? [[String: AnyObject]]{
                        let updatedRecords = records.map{ record in
                            return Utils.mapObject(record: record, mapping: mapping)
                        }
                        
                        let json = try JSONSerialization.data(withJSONObject: updatedRecords)
                        let decoder = JSONDecoder()
                        let currentContext = CoreDataStack.shared.backgroundContext
                        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = currentContext
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let items = try decoder.decode(type.self, from: json)
                        CoreDataStack.shared.save(context: currentContext)
                    }
                }
            } catch{
                print("Unexpected error: \(error).")
            }
            return result
        }
    }
}
