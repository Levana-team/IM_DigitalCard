//
//  ClientDetailViewModel.swift
//  IM_DigitalCard
//
//  Created by Elie Buff on 14/02/2021.
//

import SwiftUI
import Combine

class ClientDetailViewModel: ObservableObject{
    private var disposables = Set<AnyCancellable>()
    
    @Published var clientDetail: ClientDetail = ClientDetail()
    @Published var isLoading = true
    
    init(clientId: String){
        loadCLientDetail(clientId: clientId)
    }
    
    func loadCLientDetail(clientId: String){
        
        ClientService.shared.getClientDetails(clientId: clientId)
            .sink(receiveCompletion: {_ in}, receiveValue: {clientData in
                self.clientDetail = clientData
                self.isLoading = false
            })
            .store(in: &disposables)
    }
}


