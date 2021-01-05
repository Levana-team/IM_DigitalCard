//
//  AddressHelperViewModel.swift
//  IM_DigitalCard
//
//  Created by elie buff on 04/01/2021.
//

import Foundation
import SwiftUI
import MapKit
import Combine

class AddressHelperViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    var cancellable: AnyCancellable?
    var completer: MKLocalSearchCompleter
    
    @Published var searchQuery = ""
    @Published var completions: [MKLocalSearchCompletion] = []
    
    override init() {
        completer = MKLocalSearchCompleter()
        super.init()
        
        cancellable = $searchQuery.assign(to: \.queryFragment, on: self.completer)
        completer.delegate = self
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.completions = completer.results
    }
    
    func printAddresse(loclSearchCompletion: MKLocalSearchCompletion){
        let request = MKLocalSearch.Request(completion: loclSearchCompletion)
        
        let search = MKLocalSearch(request: request)
        
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            for item in response.mapItems {
                print(item.placemark.postalCode)
            }
        }
    }
}

extension MKLocalSearchCompletion: Identifiable {}

