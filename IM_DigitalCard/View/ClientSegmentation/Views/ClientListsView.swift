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
            ForEach(viewModel.clientListItems) { (clientList: ClientList) in
                NavigationLink(destination: ClientSegmentationItemsView(clientList: clientList)) {
                    VStack{
                        Text(clientList.name ?? "")
                    }.frame(height: 40)
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
