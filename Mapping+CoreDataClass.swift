//
//  Mapping+CoreDataClass.swift
//  IM_DigitalCard
//
//  Created by Elie Buff on 10/01/2021.
//
//

import Foundation
import CoreData

@objc(Mapping)
public class Mapping: NSManagedObject , Codable {
    enum CodingKeys: CodingKey {
        case id, objectName, sfFieldName, wrapperFieldName, isCurrency
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.objectName = try container.decode(String.self, forKey: .objectName)
        self.sfFieldName = try container.decode(String.self, forKey: .sfFieldName)
        self.wrapperFieldName = try container.decode(String.self, forKey: .wrapperFieldName)
        self.isCurrency = try container.decode(Bool.self, forKey: .isCurrency)
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(objectName, forKey: .objectName)
        try container.encode(sfFieldName, forKey: .sfFieldName)
        try container.encode(wrapperFieldName, forKey: .wrapperFieldName)
        try container.encode(isCurrency, forKey: .isCurrency)
    }
    
    static func fetchEntityMapping(context: NSManagedObjectContext, entityMappingNames:[String]) -> [String:String]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: getEntityName())
        request.predicate = NSPredicate(format: "objectName IN %@", entityMappingNames)
        request.returnsObjectsAsFaults = false
        
        var mapping = [String:String]()
        do {
            if let results = try context.fetch(request) as? [Mapping],
                results.count > 0{
                
                for result in results{
                    if let wrapperFieldName = result.wrapperFieldName, let sfFieldName = result.sfFieldName{
                        mapping[sfFieldName] = wrapperFieldName
                    }
                }
            }
        } catch {
            print("fetchEntityMapping Failed")
        }
        return mapping
    }
}
