//
//  LaunchScreenView.swift
//  IM_DigitalCard
//
//  Created by elie buff on 29/12/2020.
//

import SwiftUI

struct LaunchScreenView: View {
    @StateObject var viewModel = LaunchScreenViewModel()
    @State var openModal = false
    
    var body: some View {
        Group{
            if viewModel.isDataLoaded{
                TabBarContainerView()
            }else{
                ZStack{
                    viewModel.homeImage
                        .resizable()
                        .scaledToFill()
                }.ignoresSafeArea()
            }
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
