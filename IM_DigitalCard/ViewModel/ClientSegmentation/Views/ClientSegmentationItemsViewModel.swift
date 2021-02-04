//
//  ClientSegmentationItemsViewModel.swift
//  IM_DigitalCard
//
//  Created by Elie Buff on 19/01/2021.
//

import SwiftUI
import Combine

class ClientSegmentationItemsViewModel: ObservableObject{
    var clientSegmentationItem: ClientSegmentationViewModel
    @Published var fetchRequest: FetchRequest<Account>
    
    init(clientSegmentationItem: ClientSegmentationViewModel){
        self.clientSegmentationItem = clientSegmentationItem
        
        fetchRequest = FetchRequest<Account>(entity: Account.entity(),
                                             sortDescriptors: [NSSortDescriptor(key: "lastName", ascending: true)])
    }
    
}
