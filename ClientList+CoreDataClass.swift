//
//  ClientList+CoreDataClass.swift
//  IM_DigitalCard
//
//  Created by Elie Buff on 16/01/2021.
//
//

import Foundation
import CoreData

@objc(ClientList)
public class ClientList: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case position, descriptionText, query, id, name
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.query = try container.decodeIfPresent(String.self, forKey: .query)
        self.descriptionText = try container.decodeIfPresent(String.self, forKey: .descriptionText)
        self.position = try container.decode(Int16.self, forKey: .position)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(query, forKey: .query)
        try container.encode(descriptionText, forKey: .descriptionText)
        try container.encode(position, forKey: .position)
    }
    
    static func getClientsPredicate(clientList: ClientList, searchText:String) -> NSPredicate{
        
        let clientSearchPredicate = Account.getSearchClientsPredicate(by: searchText)
        let clientListPredictae = NSPredicate(format: "ANY clientLists == %@", clientList)
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: [clientSearchPredicate, clientListPredictae ])
    }
}
