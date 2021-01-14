//
//  Utils.swift
//  IM_DigitalCard
//
//  Created by elie buff on 29/12/2020.
//

import CoreData

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
        
        print(mappedRecord)
        return mappedRecord
    }
}
