//
//  UIImageView.swift
//  Ethno
//
//  Created by whitehorse on 2019/11/11.
//  Copyright © 2019 Ethno. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
    
  
}

extension UIImage{
    func imageWithColor(tintColor: UIColor) -> UIImage {
           UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)

           let context = UIGraphicsGetCurrentContext() as! CGContext
           context.translateBy(x: 0, y: size.height)
           context.scaleBy(x: 1, y: -1)
           context.setBlendMode(.normal)

           let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
           context.clip(to: rect, mask: self.cgImage!)
           tintColor.setFill()
           context.fill(rect)
           let newImage = UIGraphicsGetImageFromCurrentImageContext() as! UIImage
           UIGraphicsEndImageContext()

           return newImage
       }
}
