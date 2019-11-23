//
//  UINavigationItem.swift
//  Ethno
//
//  Created by whitehorse on 2019/11/9.
//  Copyright © 2019 Ethno. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    class func itemWith(colorfulImage: UIImage?, target: AnyObject, action: Selector, tag : Int) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(colorfulImage, for: .normal)
        button.frame = CGRect(x: 10.0, y: 0.0, width: 30.0, height: 30.0)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.tag = tag

        let barButtonItem = UIBarButtonItem(customView: button)
        
        let currWidth = barButtonItem.customView?.widthAnchor.constraint(equalToConstant: 30)
        currWidth?.isActive = true
        let currHeight = barButtonItem.customView?.heightAnchor.constraint(equalToConstant: 30)
        currHeight?.isActive = true
        
        return barButtonItem
    }
}


extension UINavigationController {
    func addLogoImage(image: UIImage, navItem: UINavigationItem) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height:40))
        view.addSubview(imageView)
        view.translatesAutoresizingMaskIntoConstraints = false

        navItem.titleView = view
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -10).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10.0).isActive = true

        view.heightAnchor.constraint(equalTo: navigationBar.heightAnchor).isActive = true
        view.centerXAnchor.constraint(equalTo: navigationBar.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor).isActive = true
        view.topAnchor.constraint(equalTo: navigationBar.topAnchor, constant: 0).isActive = true
    }
}
