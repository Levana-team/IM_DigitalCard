//
//  ClientSegmentationItemsView.swift
//  IM_DigitalCard
//
//  Created by Elie Buff on 19/01/2021.
//

import SwiftUI

struct ClientSegmentationItemsView: View {
    @StateObject var viewModel: ClientSegmentationItemsViewModel
    @State var searchText = ""
    
    init(clientList: ClientList){
        _viewModel = StateObject(wrappedValue: ClientSegmentationItemsViewModel(clientList: clientList));
    }
    
    var body: some View {
        VStack{
            TextField("seachBar", text: $searchText)
            FilteredListView(searchText: searchText,
                            sortDescriptors: [NSSortDescriptor(key: "lastName", ascending: true)],
                            predicate: ClientList.getClientsPredicate(clientList: viewModel.clientListItem, searchText: searchText)){ (client: Account) in
                ClientView(clientView: ClientViewModel(client: client))
            }
        }
        
    }
}

struct ClientSegmentationItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ClientSegmentationItemsView(clientList: ClientList())
    }
}
