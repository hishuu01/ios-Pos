//
//  SetupViewController.swift
//
//  Created by yo on 16/9/6.
//  Copyright © 2018年 Yo. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var itemList = ["売上項目","支払先","支払項目","会計科目"]
    var itemView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "項目设定"
        self.view.backgroundColor = UIColor.white
        itemView = UITableView(frame: self.view.frame, style: .plain)
        self.view.addSubview(itemView!)
        //リソース設定
        itemView?.delegate = self
        itemView?.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemList.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "SetupCellID")

        cell.textLabel?.text = itemList[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemView!.deselectRow(at: indexPath, animated: true)
        var nextview = UIViewController()
        switch indexPath.row {
        case 0:
            let saleitem = SaleItemMstViewController()
            nextview = saleitem
        case 1:
            let partner = PartnerMstViewController()
            nextview = partner
        case 2:
            let costitem = CostItemMstViewController()
            nextview = costitem
        case 3:
            let account = AccountMstViewController()
            nextview = account
        default:
            return
        }
        self.navigationController!.pushViewController(nextview, animated: true)
    }
}
