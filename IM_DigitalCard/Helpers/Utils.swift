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
}
