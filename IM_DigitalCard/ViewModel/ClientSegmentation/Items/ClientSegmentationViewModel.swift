//
//  ClientSegmentationViewModel.swift
//  IM_DigitalCard
//
//  Created by Elie Buff on 20/01/2021.
//

import Combine
import SwiftUI

class ClientSegmentationViewModel : ObservableObject{
    let id = UUID()
    @Published var clientSegmentation: ClientList
    
    init(clientList: ClientList){
        self.clientSegmentation = clientList
    }
    
    var name: String{
        clientSegmentation.name ?? ""
    }
}



