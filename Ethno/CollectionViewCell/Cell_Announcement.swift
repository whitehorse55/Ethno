//
//  Cell_Announcement.swift
//  Ethno
//
//  Created by whitehorse on 2019/11/11.
//  Copyright © 2019 Ethno. All rights reserved.
//

import UIKit

class Cell_Announcement: UITableViewCell {

    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var lb_description: UILabel!
    @IBOutlet weak var btn_more: UIButton!
    @IBOutlet weak var img_announce: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.layer.borderColor = UIColor.darkGray.cgColor
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.masksToBounds = true
        self.btn_more.tintColor = .darkGray
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        self.lb_title.text = ""
        self.lb_description.text = ""   
        self.img_announce.image = UIImage(named: "announce")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }
    
}
