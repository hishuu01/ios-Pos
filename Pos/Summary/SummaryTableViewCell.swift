//
//  ProductTableViewCell.swift
//  UITableViewTest
//
//  Created by yo on 18/3/20.
//  Copyright © 2018年 yo. All rights reserved.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var DateItem: UILabel!
    @IBOutlet weak var SaleAmount: UILabel!
    @IBOutlet weak var SaleQty: UILabel!
    @IBOutlet weak var PayAmount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
