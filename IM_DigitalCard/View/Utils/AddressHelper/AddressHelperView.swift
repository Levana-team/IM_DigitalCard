//
//  AddressHelperView.swift
//  IM_DigitalCard
//
//  Created by elie buff on 04/01/2021.
//

import SwiftUI
import MapKit

struct AddressHelperView: View {
    @StateObject var viewModel = AddressHelperViewModel()
    @Binding var street: String
    @Binding var city: String
    @Binding var country: String
    @Binding var postalCode: String
    @Binding var state: String
    
    
    var body: some View {
        VStack {
            SearchBar(text: $viewModel.searchQuery)
            List(viewModel.completions) { completion in
                VStack(alignment: .leading) {
                    Text(completion.title)
                    Text(completion.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }.onTapGesture {
                    getAddresseData(loclSearchCompletion: completion)
                }
            }.navigationBarTitle(Text("Search near me"))
        }
    }
    
    func getAddresseData(loclSearchCompletion: MKLocalSearchCompletion){
        let request = MKLocalSearch.Request(completion: loclSearchCompletion)
        
        let search = MKLocalSearch(request: request)
        
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            for item in response.mapItems {
                self.street =  "\(item.placemark.subThoroughfare ?? "") \(item.placemark.thoroughfare ?? "")"
                self.city = item.placemark.locality ?? ""
                self.postalCode = item.placemark.postalCode ?? ""
                self.state = item.placemark.subAdministrativeArea ?? ""
                self.country = item.placemark.country ?? ""
            }
        }
    }
}

struct AddressHelperView_Previews: PreviewProvider {
    static var previews: some View {
        AddressHelperView(street: .constant(""), city: .constant(""), country: .constant(""), postalCode: .constant(""), state: .constant(""))
    }
}
