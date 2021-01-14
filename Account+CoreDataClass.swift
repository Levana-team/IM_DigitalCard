//
//  Account+CoreDataClass.swift
//  IM_DigitalCard
//
//  Created by Elie Buff on 10/01/2021.
//
//

import Foundation
import CoreData

@objc(Account)
public class Account: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case id, lastName, firstName
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
    }
    
    static func getSearchClientsPredicate( by searchText:String, isFavorite:Bool? = nil, isLastContacted:Bool? = nil) -> NSPredicate{
        var predicates = [ NSPredicate(format: "id != nil") ]
        if let clientSearchPredicate = getClientSearchPredicate(forText: searchText){
            predicates.append(clientSearchPredicate)
        }
        
        if let isFavorite = isFavorite{
            predicates.append(NSPredicate(format: "favorite == %@", NSNumber(value: isFavorite)))
        }
        if let _ = isLastContacted{
            predicates.append(NSPredicate(format: "lastContactedDate != nil"))
        }
        
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
    
    static private func getClientSearchPredicate(forText searchText: String) -> NSPredicate?{
        if searchText != ""{
            var predicates = [NSPredicate]()
            
            let searchArray = searchText.components(separatedBy: " ")
            
            for text in searchArray{
                predicates.append(NSPredicate(format: "firstName contains[cd] %@", text))
                predicates.append(NSPredicate(format: "lastName contains[cd] %@", text))
            }
            //predicates.append(NSPredicate(format: "email contains[cd] %@", searchText))
            //predicates.append(NSPredicate(format: "mobile contains[cd] %@", searchText))
            
            return NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        }
        return nil
    }
}
