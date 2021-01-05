//
//  DrawingView.swift
//  IM_DigitalCard
//
//  Created by elie buff on 03/01/2021.
//

import SwiftUI
import PencilKit

struct DrawingView : UIViewRepresentable {
    
    @Binding var canvas : PKCanvasView
    @Binding var isDraw : Bool
    @Binding var type : PKInkingTool.InkType
    @Binding var color : Color
    
    let onSaved: (_ signatureImage: UIImage?) -> Void
    
    var ink : PKInkingTool{
        PKInkingTool(type, color: UIColor(color))
    }
    
    let eraser = PKEraserTool(.bitmap)
    
    func makeUIView(context: Context) -> PKCanvasView{
        canvas.drawingPolicy = .anyInput
        canvas.tool = isDraw ? ink : eraser
        canvas.delegate = context.coordinator
        
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.tool = isDraw ? ink : eraser
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(canvas: $canvas, onSaved: onSaved)
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var canvas: Binding<PKCanvasView>
        let onSaved: (_ signatureImage: UIImage?) -> Void

        init(canvas: Binding<PKCanvasView>, onSaved: @escaping (_ signatureImage: UIImage?) -> Void) {
            self.canvas = canvas
            self.onSaved = onSaved
        }
   //canvas.drawing.image(from: canvas.drawing.bounds, scale: 1)
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            if !canvasView.drawing.bounds.isEmpty {
                let imgData = canvasView.drawing.image(from: canvasView.drawing.bounds, scale: 1)
                onSaved(imgData)
            }else{
                onSaved(nil)
            }
        }
    }
}
