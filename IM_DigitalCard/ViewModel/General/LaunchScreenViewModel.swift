//
//  LaunchScreenViewModel.swift
//  IM_DigitalCard
//
//  Created by elie buff on 29/12/2020.
//

import Combine
import SwiftUI

class LaunchScreenViewModel: ObservableObject{
    private var disposables = Set<AnyCancellable>()
    
    @Published var isDataLoaded: Bool = false
    
    init(){
        self.isDataLoaded = true
        /*
        if GlobalSyncService.shared.needToPerformSync(){
            GlobalSyncService.shared.retrieveData()
            .sink(receiveCompletion: { _ in}, receiveValue: { items in
                self.isDataLoaded = true
            }).store(in: &disposables)
        }*/
    }
    
    var homeImage: Image{
        if let docUrl = Document.getDocumentUrl(by: "Home"), let homeImg = FileManagement.sharedInstance.getImageFromDirectory(docUrl){
            return homeImg
        }
        return Image("home")
    }
}
