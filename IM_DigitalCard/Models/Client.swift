//
//  Client.swift
//  IM_DigitalCard
//
//  Created by elie buff on 02/01/2021.
//

import Foundation

struct Client : Codable {
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var street: String
    var city: String
    var country: String
    var postalCode: String
    var state: String
    var signatureImgData: Data
    
    
    init(){
        firstName = ""
        lastName = ""
        email = ""
        phone = ""
        street = ""
        city = ""
        country = ""
        postalCode = ""
        state = ""
        signatureImgData = Data()
    }
}

