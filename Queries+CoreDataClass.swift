//
//  Queries+CoreDataClass.swift
//  IM_DigitalCard
//
//  Created by Elie Buff on 14/01/2021.
//
//

import Foundation
import CoreData

@objc(Queries)
public class Queries: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case name, query
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.query = try container.decode(String.self, forKey: .query)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(query, forKey: .query)
    }
    
    static func getQuery(by name: String)-> String{
        let context = CoreDataStack.shared.backgroundContext
        let queryFetch = NSFetchRequest<NSFetchRequestResult>(entityName: getEntityName())
        let pred1 = NSPredicate(format: "name = %@", name)
        queryFetch.predicate = pred1
        queryFetch.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            if let fetchedQueries = try context.fetch(queryFetch) as? [Queries], fetchedQueries.count > 0{
                return fetchedQueries.first?.query ?? ""
            }
            
        } catch {
            fatalError("Failed to fetch storeUsers: \(error)")
        }
        return ""
    }

}
