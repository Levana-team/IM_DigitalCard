//
//  NewClientView.swift
//  IM_DigitalCard
//
//  Created by elie buff on 02/01/2021.
//

import SwiftUI

struct NewClientView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = NewClientViewModel()
    
    var body: some View {
        NavigationView{
            VStack{
            
                Form{
                    TextField("First Name", text: $viewModel.clientItem.firstName)
                    TextField("Last Name", text: $viewModel.clientItem.lastName)
                    TextField("Email", text: $viewModel.clientItem.email)
                    TextField("Phone", text: $viewModel.clientItem.phone)
                    TextField("Street", text: $viewModel.clientItem.street)
                    TextField("City", text: $viewModel.clientItem.city)
                    TextField("Postal Code", text: $viewModel.clientItem.postalCode)
                    TextField("State", text: $viewModel.clientItem.state)
                    TextField("Country", text: $viewModel.clientItem.country)
                }
                SignatureView(signatureImage: $viewModel.signatureImage)
                    .background(Color.red)
                
                Button("Check Duplicate", action: {
                    if validateForm(){
                        viewModel.checkDuplicate()
                    }
                })
                Button("Save", action: {
                    if validateForm(){
                        viewModel.addNewClient()
                    }
                })
                NavigationLink(destination:AddressHelperView(street: $viewModel.clientItem.street, city: $viewModel.clientItem.city, country: $viewModel.clientItem.country, postalCode: $viewModel.clientItem.postalCode, state: $viewModel.clientItem.state)) {
                    Text("Retrieve Address")
                }
                
            }
            .navigationBarTitle("Add New Client", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "plus.square.fill")
                        .font(.largeTitle)
                }).foregroundColor(Color.blue)
            )
        }
    }
    
    func validateForm() -> Bool{
        
        if viewModel.clientItem.email.isValidEmail{
            return true
        }else{
            print("Invalid Email")
        }
        
        return false
    }
}

struct NewClientView_Previews: PreviewProvider {
    static var previews: some View {
        NewClientView()
    }
}
