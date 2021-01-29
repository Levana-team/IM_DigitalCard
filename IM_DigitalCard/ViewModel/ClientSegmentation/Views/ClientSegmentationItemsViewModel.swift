//
//  ClientSegmentationItemsViewModel.swift
//  IM_DigitalCard
//
//  Created by Elie Buff on 19/01/2021.
//

import SwiftUI
import Combine

class ClientSegmentationItemsViewModel: ObservableObject{
    var clientListItem: ClientList
    @Published var fetchRequest: FetchRequest<Account>
    
    init(clientList: ClientList){
        self.clientListItem = clientList
        
        fetchRequest = FetchRequest<Account>(entity: Account.entity(),
                                             sortDescriptors: [NSSortDescriptor(key: "lastName", ascending: true)])
    }
    
}
