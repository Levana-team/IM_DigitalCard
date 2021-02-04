//
//  ClientListsView.swift
//  IM_DigitalCard
//
//  Created by Elie Buff on 18/01/2021.
//

import SwiftUI

struct ClientListsView: View {
    @StateObject var viewModel = ClientListsViewModel()
    
    var body: some View {
        VStack{
            ForEach(viewModel.clientSegmentationItems, id: \.id) { clientSegmentationItem in
                NavigationLink(destination: ClientSegmentationItemsView(clientSegmentationItem: clientSegmentationItem)) {
                    ClientSegmentationView(clientSegmentationItem: clientSegmentationItem)
                }
            }
        }
    }
}

struct ClientListsView_Previews: PreviewProvider {
    static var previews: some View {
        ClientListsView()
    }
}
