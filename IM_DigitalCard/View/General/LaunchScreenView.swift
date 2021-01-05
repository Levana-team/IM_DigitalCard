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
        ZStack{
            viewModel.homImage
                .resizable()
                .scaledToFill()
            Text("Hello World")
            Button("Start", action: {
                openModal.toggle()
            })
        }.fullScreenCover(isPresented: $openModal, content: {
            NewClientView()
        })
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
