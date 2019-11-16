//
//  Cell_Advertise.swift
//  Ethno
//
//  Created by whitehorse on 2019/11/10.
//  Copyright © 2019 Ethno. All rights reserved.
//

import UIKit

class Cell_Advertise: UICollectionViewCell {

    lazy var backgroundimage : UIImageView = {
        
        let backimg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height))
        backimg.contentMode = .scaleToFill
            return backimg
        
       }()
       
       override init(frame: CGRect) {
           super.init(frame: frame)
           
           contentView.layer.cornerRadius = 10.0
           contentView.layer.masksToBounds = true
           contentView.backgroundColor = .clear
           contentView.addSubview(backgroundimage)
       }
       
       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

}
