//
//  SaleViewController.swift
//  POS
//
//  Created by Yo on 18/3/6.
//  Copyright © 2018年 yo. All rights reserved.
//

import UIKit

class ItemListViewController: UITableViewController {
    var ItemNo:String?
    var itemList = Array<SaleItemModel>()
    var selectItem:((SaleItemModel)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "項目リスト"
        itemList = SaleItemManager.find()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //dataArray = DataManager.getGroupData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "itemCellID"
        let cell = UITableViewCell(style: .value1, reuseIdentifier: cellID)
        
        let model = itemList[indexPath.row]
        cell.textLabel?.text = model.itemName!
        cell.detailTextLabel?.text = Common.formatNumberStr(num: model.price!)
        if model.itemNo! == self.ItemNo {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = itemList[indexPath.row]
        self.selectItem!(model)
        self.navigationController!.popViewController(animated: true)
    }


}

