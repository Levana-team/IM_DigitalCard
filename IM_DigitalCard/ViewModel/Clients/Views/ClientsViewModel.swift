//
//  ClientsViewModel.swift
//  IM_DigitalCard
//
//  Created by Elie Buff on 14/01/2021.
//

import SwiftUI
import Combine

class ClientsViewModel: ObservableObject{
    @Published var fetchRequest: FetchRequest<Account>
    
    init(){
        fetchRequest = FetchRequest<Account>(entity: Account.entity(),
                                             sortDescriptors: [NSSortDescriptor(key: "lastName", ascending: true)])
    }

}
