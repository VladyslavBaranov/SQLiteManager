//
//  IconViewController.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 09.02.2022.
//

import UIKit

final class IconViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        let imageView = UIImageView(frame: .init(x: 0, y: 0, width: 800, height: 800))
        view.addSubview(imageView)
        imageView.center = view.center
        imageView.image = UIImage(data: drawImage())
        
        
        // DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
        //     let controller = UIActivityViewController(activityItems: [self.drawImage()], applicationActivities: [])
        //     controller.popoverPresentationController?.sourceView = imageView
        //     self.present(controller, animated: true, completion: nil)
        // }
        
    }
    func drawImage() -> Data {
        let renderer = UIGraphicsImageRenderer(size: .init(width: 1024, height: 1024))
        
        let img = renderer.pngData { context in
            let ctx = context.cgContext
            
            let roundedRectPath = CGPath(
                roundedRect: .init(x: 0, y: 0, width: 1024, height: 1024),
                cornerWidth: 0, cornerHeight: 0, transform: nil)
            
            ctx.setBlendMode(.xor)
            
            ctx.addPath(roundedRectPath)
            // ctx.addRect(.init(x: 512, y: 0, width: 512, height: 512))
            ctx.setFillColor(UIColor.black.cgColor)
            ctx.fillPath()
            
            
            ctx.addEllipse(in: .init(x: 202, y: 217, width: 620, height: 290))
            ctx.setFillColor(UIColor.cyan.cgColor)
            ctx.fillPath()
            
            ctx.addEllipse(in: .init(x: 202, y: 367, width: 620, height: 290))
            ctx.setFillColor(UIColor.white.cgColor)
            ctx.fillPath()
            
            ctx.addEllipse(in: .init(x: 202, y: 517, width: 620, height: 290))
            ctx.setFillColor(UIColor.magenta.cgColor)
            ctx.fillPath()
        }
        
        return img
    }

}
