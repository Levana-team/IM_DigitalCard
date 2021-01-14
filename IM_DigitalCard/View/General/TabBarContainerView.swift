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
                ClientListViews()
            }.tabItem {
                Image(systemName: "phone.fill")
                Text("Client")
            }
        }
    }
}

struct TabBarContainerView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarContainerView()
    }
}
