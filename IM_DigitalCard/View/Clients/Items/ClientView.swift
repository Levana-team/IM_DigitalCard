//
//  ClientView.swift
//  IM_DigitalCard
//
//  Created by Elie Buff on 19/01/2021.
//

import SwiftUI

struct ClientView: View {
    var clientView: ClientViewModel
    
    var body: some View {
        NavigationLink(destination: ClientDetailView()) {
            VStack{
                Text(clientView.fullName)
            }
        }
    }
}

struct ClientView_Previews: PreviewProvider {
    static var previews: some View {
        ClientView(clientView: ClientViewModel(client: Account()))
    }
}
