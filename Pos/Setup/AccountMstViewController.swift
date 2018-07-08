//
//  SetupViewController.swift
//
//  Created by yo on 16/9/6.
//  Copyright © 2018年 Yo. All rights reserved.
//

import UIKit

class AccountMstViewController: UITableViewController {
    
    var accountList = Array<AccountModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "会計科目"
        self.view.backgroundColor = UIColor.white
        EditNavigationItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        accountList = AccountManager.find()
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
        let itemedit = AccountEditViewController()
        self.navigationController?.pushViewController(itemedit, animated: true)
    }
    
    @objc func ExitEdit() {
        self.tableView.isEditing = false
        EditNavigationItem()
        AccountManager.deleteAll()
        for idx in 1...accountList.count {
            let model = accountList[idx-1]
            model.row = nil
            AccountManager.insert(record: model)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return accountList.count
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "AccountCellID")

        let model = accountList[indexPath.row]
        cell.textLabel?.text = model.accountName!
        cell.accessoryType = .disclosureIndicator
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(gestureReconizer:)))
        longPress.minimumPressDuration = 1
        longPress.delaysTouchesBegan = true
        cell.addGestureRecognizer(longPress)
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
            let itemedit = AccountEditViewController()
            itemedit.itemModel = accountList[index.row]
            self.navigationController?.pushViewController(itemedit, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            accountList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let moveitem = accountList[sourceIndexPath.row]
        
        accountList.remove(at: sourceIndexPath.row)
        accountList.insert(moveitem, at: destinationIndexPath.row)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let itemlist = CostItemListViewController()
        itemlist.AccountNo = accountList[indexPath.row].accountNo
        self.navigationController?.pushViewController(itemlist, animated: true)
    }
    

}
