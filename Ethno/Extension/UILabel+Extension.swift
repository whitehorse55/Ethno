//
//  UILabel+Extension.swift
//  Ethno
//
//  Created by whitehorse on 2019/11/9.
//  Copyright © 2019 Ethno. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {

     func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {

          let border = CALayer()

          switch edge {
          case UIRectEdge.top:
              border.frame = CGRect.zero
              border.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: thickness)
              break
          case UIRectEdge.bottom:
              border.frame = CGRect(x: 0, y: self.bounds.height - thickness, width: self.bounds.width, height: thickness)
              break
          case UIRectEdge.left:
              border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.bounds.height)
              break
          case UIRectEdge.right:
              border.frame = CGRect(x: self.bounds.width - thickness, y: 0, width: thickness, height: self.bounds.height)
              break
          default:
              break
          }

          border.backgroundColor = color.cgColor;

          self.addSublayer(border)
      }

}

