//
//  ClientsView.swift
//  IM_DigitalCard
//
//  Created by Elie Buff on 14/01/2021.
//

import SwiftUI

struct ClientListViews: View {
    @State var searchText = ""
    
    var body: some View {
        VStack{
            TextField("seachBar", text: $searchText)
            FilteredListView(searchText: searchText,
                            sortDescriptors: [NSSortDescriptor(key: "lastName", ascending: true)],
                            predicate: Account.getSearchClientsPredicate(by: searchText)){ (client: Account) in
                ClientView(clientView: ClientViewModel(client: client))
            }
        }
        
    }
}

struct ClientsView_Previews: PreviewProvider {
    static var previews: some View {
        ClientListViews()
    }
}
