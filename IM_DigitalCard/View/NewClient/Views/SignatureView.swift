//
//  SignatureView.swift
//  IM_DigitalCard
//
//  Created by elie buff on 03/01/2021.
//

import SwiftUI
import PencilKit

struct SignatureView: View {
    @State var canvas = PKCanvasView()
    @State var isDraw = true
    @State var color : Color = .black
    @State var type : PKInkingTool.InkType = .pen
    @State var colorPicker = false
    
    @Binding var signatureImage: UIImage?
    
    var body: some View {
        
        VStack{
            DrawingView(canvas: $canvas, isDraw: $isDraw,type: $type,color: $color, onSaved: { img in
                signatureImage = img
            }).padding()
            
            Button("Empty Drawing", action: {
                canvas.drawing = PKDrawing()
            })
        }.background(Color.red)
            
    }
    
   
        
    //func getImage() -> {
           
            
        //let image = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1)

       // }
}

struct SignatureView_Previews: PreviewProvider {
    static var previews: some View {
        SignatureView(signatureImage: .constant(nil))
    }
}
