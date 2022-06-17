//
//  ViewController.swift
//  DibujoLibre
//
//  Created by marco rodriguez on 17/06/22.
//

import UIKit

class Canvas: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setStrokeColor(UIColor.blue.cgColor)
        context.setLineWidth(3)
        context.setLineCap(.round)
        
        lines.forEach { (line) in
            for (i, p) in line.enumerated() {
                if i == 0 {
                    context.move(to: p)
                } else {
                    context.addLine(to: p)
                }
            }
        }
        
        context.strokePath()
    }
    
    var line = [CGPoint]()
    
    var lines = [[CGPoint]]()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append([CGPoint]())
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: nil) else { return }

        guard var lastLine = lines.popLast() else { return }
        lastLine.append(point)
        
        lines.append(lastLine)
        
        print(lastLine)
        
        setNeedsDisplay()
    }
}

class ViewController: UIViewController {

   
    
    @IBOutlet weak var vistaPreviaFirmaImagen: UIImageView!
    @IBOutlet weak var vistaFirma: UIView!

    let canvas = Canvas()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vistaFirma.addSubview(canvas)
        canvas.backgroundColor = .white
        canvas.frame = view.frame
    }
    
    @IBAction func volverFirmarBtn(_ sender: UIButton) {
        canvas.lines = [[CGPoint]]()
        canvas.line = [CGPoint]()
        vistaFirma.addSubview(canvas)
    }
    

    @IBAction func guardarBtn(_ sender: UIButton) {
        let renderer = UIGraphicsImageRenderer(size: vistaFirma.bounds.size)
        vistaPreviaFirmaImagen.image = renderer.image { ctx in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
    }
    
}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.cornerRadius
        }
        
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
