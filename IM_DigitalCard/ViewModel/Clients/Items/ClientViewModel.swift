//
//  ClientViewModel.swift
//  IM_DigitalCard
//
//  Created by Elie Buff on 19/01/2021.
//

import Combine
import SwiftUI

class ClientViewModel : ObservableObject{
    let id = UUID()
    @Published var client: Account
    
    init(client: Account){
        self.client = client
    }
    
    var clientId: String{
        client.id ?? ""
    }
    
    var firstName: String{
        "\(client.firstName ?? "No")"
    }
    
    var lastName: String{
        "\(client.lastName ?? "Name")"
    }
    
    var fullName: String{
        "\(firstName) \(lastName)"
    }
    
    var initial: String{
        "\(firstName.first!.uppercased())\(lastName.first!.uppercased())"
    }
}


