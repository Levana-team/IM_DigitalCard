//
//  ClientSegmentationView.swift
//  IM_DigitalCard
//
//  Created by Elie Buff on 20/01/2021.
//

import SwiftUI

struct ClientSegmentationView: View {
    var clientSegmentationItem: ClientSegmentationViewModel
    
    var body: some View {
        VStack{
            Text(clientSegmentationItem.name)
        }
    }
}

struct ClientSegmentationView_Previews: PreviewProvider {
    static var previews: some View {
        ClientSegmentationView(clientSegmentationItem: ClientSegmentationViewModel(clientList: ClientList()))
    }
}
