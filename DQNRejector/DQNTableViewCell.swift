//
//  DQNTableViewCell.swift
//  DQNRejector
//
//  Created by Imajin Kawabe on 2018/07/22.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit

class DQNTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
