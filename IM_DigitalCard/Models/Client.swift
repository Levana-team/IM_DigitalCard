//
//  Client.swift
//  IM_DigitalCard
//
//  Created by elie buff on 02/01/2021.
//

import Foundation

struct Client{
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var street: String
    var city: String
    var country: String
    var postalCode: String
    var state: String
    var signatureImgData: Data?
    
    
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
    }
}

extension Client: Codable {
    enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case email
        case phone
        case street
        case city
        case country
        case postalCode
        case state
        case signatureImgData
    }
    
    init(from decoder: Decoder) throws {
       let values = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try values.decode(String.self, forKey: .firstName)
        lastName = try values.decode(String.self, forKey: .lastName)
        email = try values.decodeIfPresent(String.self, forKey: .email) ?? ""
        phone = try values.decodeIfPresent(String.self, forKey: .phone) ?? ""
        street = try values.decodeIfPresent(String.self, forKey: .street) ?? ""
        city = try values.decodeIfPresent(String.self, forKey: .city) ?? ""
        country = try values.decodeIfPresent(String.self, forKey: .country) ?? ""
        postalCode = try values.decodeIfPresent(String.self, forKey: .postalCode) ?? ""
        state = try values.decodeIfPresent(String.self, forKey: .state) ?? ""
    }
}

