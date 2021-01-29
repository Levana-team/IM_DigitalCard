//
//  CoreDataUtils.swift
//  IM_DigitalCard
//
//  Created by Elie Buff on 14/01/2021.
//

import Foundation
import CoreData

class CoreDataUtils{
    static let shared = CoreDataUtils()
    
    func saveToCoredata<U: Decodable>(data: [[String : AnyObject]], type: U.Type){
        do {
            let json = try JSONSerialization.data(withJSONObject: data)
            let decoder = JSONDecoder()
            let currentContext = CoreDataStack.shared.backgroundContext
            decoder.userInfo[CodingUserInfoKey.managedObjectContext] = currentContext
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let _ = try decoder.decode(type.self, from: json)
            CoreDataStack.shared.save(context: currentContext)
        } catch {
            print(error)
        }
    }
}
