//
//  ClientListsViewModel.swift
//  IM_DigitalCard
//
//  Created by Elie Buff on 18/01/2021.
//

import SwiftUI
import Combine

class ClientListsViewModel: ObservableObject{
    @Published var clientListItems: [ClientList]
    
    init(){
        clientListItems = ClientList.getRecords() as! [ClientList]
    }
    
    func onClientListClick(clientListItem: ClientList){
        print(clientListItem.clients?.count)
    }
}
