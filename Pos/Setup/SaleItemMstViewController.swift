//
//  SetupViewController.swift
//
//  Created by yo on 16/9/6.
//  Copyright © 2018年 Yo. All rights reserved.
//

import UIKit

class SaleItemMstViewController: UITableViewController {
    
    var itemList = Array<SaleItemModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "売上項目"
        self.view.backgroundColor = UIColor.white
        EditNavigationItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        itemList = SaleItemManager.find()
        self.tableView.reloadData()
    }
    
    func EditNavigationItem() {
        let editButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(EntryEdit))
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(AddItem))
        self.navigationItem.rightBarButtonItems = [editButtonItem, addButtonItem]
    }
    
    func FinishNavigationItem() {
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ExitEdit))
        self.navigationItem.rightBarButtonItems = [doneButtonItem]
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
        SaleItemManager.deleteAll()
        for idx in 1...itemList.count {
            let model = itemList[idx-1]
            model.row = nil
            SaleItemManager.insert(record: model)
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemList.count
    }
    
    
    /*override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }*/
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "SaleItemMstCellID")

        let model = itemList[indexPath.row]
        cell.textLabel?.text = model.itemName!
        cell.detailTextLabel?.text = "¥" + Common.formatNumberStr(num: model.price!)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(gestureReconizer:)))
        longPress.minimumPressDuration = 1
        longPress.delaysTouchesBegan = true
        cell.addGestureRecognizer(longPress)
        //cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if self.tableView.isEditing == true {
            return
        }
        let p = gestureReconizer.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: p)
        
        if let index = indexPath {
            self.tableView.selectRow(at: index, animated: true, scrollPosition:UITableViewScrollPosition.none)
            
            if gestureReconizer.state != UIGestureRecognizerState.ended {
                return
            }
            tableView.deselectRow(at: index, animated: true)
            let itemedit = SaleItemEditViewController()
            itemedit.itemModel = itemList[index.row]
            self.navigationController?.pushViewController(itemedit, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        //let itemedit = SaleItemEditViewController()
        //itemedit.itemModel = itemList[indexPath.row]
        //self.navigationController?.pushViewController(itemedit, animated: true)
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
}
