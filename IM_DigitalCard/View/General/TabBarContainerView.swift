//
//  TabBarContainerView.swift
//  IM_DigitalCard
//
//  Created by Elie Buff on 14/01/2021.
//

import SwiftUI

struct TabBarContainerView: View {
    var body: some View {
        TabView {
            NavigationView{
                NewClientView()
            }.tabItem {
                Image(systemName: "phone.fill")
                Text("New Client")
            }
            
            NavigationView{
                ClientListViews()
            }.tabItem {
                Image(systemName: "phone.fill")
                Text("Client")
            }
            
            NavigationView{
                ClientListsView()
            }.tabItem {
                Image(systemName: "phone.fill")
                Text("Client List")
            }
        }
    }
}

struct TabBarContainerView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarContainerView()
    }
}
