//
//  ClientListsViewModel.swift
//  IM_DigitalCard
//
//  Created by Elie Buff on 18/01/2021.
//

import SwiftUI
import Combine

class ClientListsViewModel: ObservableObject{
    @Published var clientSegmentationItems: [ClientSegmentationViewModel]
    
    init(){
        clientSegmentationItems = (ClientList.getRecords() as! [ClientList]).map{ClientSegmentationViewModel(clientList: $0)}
    }
    
    func onClientListClick(clientListItem: ClientList){
        print(clientListItem.clients?.count)
    }
}
