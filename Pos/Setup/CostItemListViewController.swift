//
//  SetupViewController.swift
//
//  Created by yo on 16/9/6.
//  Copyright © 2018年 Yo. All rights reserved.
//

import UIKit

class CostItemListViewController: UITableViewController {
    
    var itemList = Array<CostItemModel>()
    var AccountNo: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "関連支払項目一覧"
        self.view.backgroundColor = UIColor.white
        //EditNavigationItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        itemList = CostItemManager.find(accNo:AccountNo!)
        self.tableView.reloadData()
    }
    
    func EditNavigationItem() {
        let editButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(EntryEdit))
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(AddItem))
        self.navigationItem.rightBarButtonItems = [editButtonItem, addButtonItem]
    }
    
    func FinishNavigationItem() {
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ExitEdit))
        self.navigationItem.rightBarButtonItem = doneButtonItem
    }
    
    
    @objc func EntryEdit() {
        self.tableView.isEditing = true
        FinishNavigationItem()
    }
    
    @objc func AddItem() {
        let itemedit = SaleItemEditViewController()
        self.navigationController?.pushViewController(itemedit, animated: true)
    }
    
    @objc func ExitEdit() {
        self.tableView.isEditing = false
        EditNavigationItem()
        CostItemManager.deleteAll()
        for idx in 1...itemList.count {
            let model = itemList[idx-1]
            model.row = nil
            CostItemManager.insert(record: model)
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemList.count
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 30
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "CostItemCellID")

        let model = itemList[indexPath.row]
        cell.textLabel?.text = model.itemName!

        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            itemList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let moveitem = itemList[sourceIndexPath.row]
        
        itemList.remove(at: sourceIndexPath.row)
        itemList.insert(moveitem, at: destinationIndexPath.row)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}
