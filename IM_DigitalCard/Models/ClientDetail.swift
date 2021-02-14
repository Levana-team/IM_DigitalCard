//
//  ClientDetail.swift
//  IM_DigitalCard
//
//  Created by Elie Buff on 14/02/2021.
//

import Foundation

struct ClientDetail : Codable {
    let client: Client
    
    
    init(){
        self.client = Client()
    }
}
