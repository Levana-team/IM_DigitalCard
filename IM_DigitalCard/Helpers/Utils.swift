//
//  Utils.swift
//  IM_DigitalCard
//
//  Created by elie buff on 29/12/2020.
//

import CoreData


enum DateError: String, Error {
    case invalidDate
}

public class Utils{
    public static func getPlistValue(for key:String)->Any?{
        guard  let infoPlist =  Bundle.main.infoDictionary else{
            return nil;
        }
        return infoPlist[key]
    }
    
    public static func mapObject(record: [String: AnyObject], mapping: [String:String]) -> [String: AnyObject]{
        let mappedRecord = record.reduce([String: AnyObject](), { result, item in
            var resultData = result
            
            if let key = mapping[item.key]{
                resultData[key] = item.value
            }
            return resultData
        })
        
        return mappedRecord
    }
    
    public static func getDefaultDecoder(context: NSManagedObjectContext) -> JSONDecoder{
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        let decoder = JSONDecoder()
        
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = context
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            if let date = formatter.date(from: dateStr) {
                return date
            }
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
            if let date = formatter.date(from: dateStr) {
                return date
            }
            formatter.dateFormat = "yyyy-MM-dd"
            if let date = formatter.date(from: dateStr) {
                return date
            }
            throw DateError.invalidDate
        })
        
        return decoder;
    }
}
