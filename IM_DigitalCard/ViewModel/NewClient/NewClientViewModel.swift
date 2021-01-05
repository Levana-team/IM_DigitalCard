//
//  NewClientViewModel.swift
//  IM_DigitalCard
//
//  Created by elie buff on 02/01/2021.
//

import SwiftUI
import Combine

class NewClientViewModel: ObservableObject{
    private var disposables = Set<AnyCancellable>()
    
    @Published var clientItem: Client
    @Published var signatureImage: UIImage?
    
    init(){
        clientItem = Client()
    }
    
    func checkDuplicate(){
        ClientService.shared.checkDuplicate(clientItem: clientItem)
            .sink(receiveCompletion: {_ in}) {
            print($0)
        }.store(in: &disposables)
    }
    
    func addNewClient(){
        if let signatureImage = signatureImage{
            clientItem.signatureImgData = signatureImage.jpegData(compressionQuality: 1)!
            ClientService.shared.saveNewClient(clientItem: clientItem).sink(receiveCompletion: {_ in}) {
                print($0)
            }.store(in: &disposables)
        }
    }
    
}

