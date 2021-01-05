//
//  Translation+CoreDataClass.swift
//  IM_DigitalCard
//
//  Created by elie buff on 29/12/2020.
//
//

import Foundation
import CoreData


enum DecoderConfigurationError: Error {
  case missingManagedObjectContext
}

@objc(Translation)
public class Translation: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case label, en, fr
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
              throw DecoderConfigurationError.missingManagedObjectContext
            }

            self.init(context: context)

            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.label = try container.decode(String.self, forKey: .label)
            self.en = try container.decode(String.self, forKey: .en)
            self.fr = try container.decode(String.self, forKey: .fr)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(label, forKey: .label)
        try container.encode(en, forKey: .en)
        try container.encode(fr, forKey: .fr)
      }
}
