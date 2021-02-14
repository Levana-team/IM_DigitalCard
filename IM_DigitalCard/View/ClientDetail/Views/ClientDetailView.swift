//
//  ClientDetailView.swift
//  IM_DigitalCard
//
//  Created by Elie Buff on 19/01/2021.
//

import SwiftUI

struct ClientDetailView: View {
    @StateObject var viewModel: ClientDetailViewModel
    
    init(clientId: String){
        _viewModel = StateObject(wrappedValue: ClientDetailViewModel(clientId: clientId));
    }

    var body: some View {
        VStack{
            Text(viewModel.clientDetail.client.firstName)
            Text(viewModel.clientDetail.client.lastName)
        }
    }
}

struct ClientDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ClientDetailView(clientId: "")
    }
}
