//
//  ProductTableViewCell.swift
//  UITableViewTest
//
//  Created by yo on 18/3/20.
//  Copyright © 2018年 yo. All rights reserved.
//

import UIKit

class SelectTableViewCell: UITableViewCell {

    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var SwitchField: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
