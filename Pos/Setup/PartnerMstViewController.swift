//
//  SetupViewController.swift
//
//  Created by yo on 16/9/6.
//  Copyright © 2018年 Yo. All rights reserved.
//

import UIKit

class PartnerMstViewController: UITableViewController {
    
    var PartnerList = Array<PartnerModel>()
    var partnerModel: PartnerModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "支払先设定"
        self.view.backgroundColor = UIColor.white
        EditNavigationItem()
        PartnerList = PartnerManager.find()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PartnerList = PartnerManager.find()
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
        /*
        self.partnerModel = PartnerModel()
        self.partnerModel?.partnerNo = ""
        self.partnerModel?.partnerName = ""
        EditItem()*/
        let itemedit = PartnerEditViewController()
        self.navigationController?.pushViewController(itemedit, animated: true)
    }
    
    func EditItem() {
        let alertController = UIAlertController(title: "支払先", message: "支払先名称を入力下さい。", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "名称"
            textField.text = self.partnerModel!.partnerName!
        }
        let alertItem = UIAlertAction(title: "キャンセル", style: .cancel, handler: {(UIAlertAction) in
            return
        })
        let alertItemAdd = UIAlertAction(title: "確定", style: .default, handler: {(UIAlertAction) -> Void in
            //进行判断
            if alertController.textFields?.first!.text == "" {
                return
            }
            if self.partnerModel!.partnerNo! == "" {
                self.partnerModel!.partnerNo = PartnerManager.getNextNo()
                self.partnerModel!.partnerName = alertController.textFields!.first!.text
                PartnerManager.insert(record: self.partnerModel!)
                self.PartnerList.append(self.partnerModel!)
            }
            else {
                self.partnerModel!.partnerName = alertController.textFields!.first!.text
                PartnerManager.update(record: self.partnerModel!)
            }
            self.tableView.reloadData()
        })
        alertController.addAction(alertItem)
        alertController.addAction(alertItemAdd)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @objc func ExitEdit() {
        self.tableView.isEditing = false
        EditNavigationItem()
        PartnerManager.deleteAll()
        for idx in 1...PartnerList.count {
            let model = PartnerList[idx-1]
            model.row = nil
            PartnerManager.insert(record: model)
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return PartnerList.count
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "PartnerCellID")

        let model = PartnerList[indexPath.row]
        cell.textLabel?.text = model.partnerName!
        
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
            //self.partnerModel = PartnerList[index.row]
            //EditItem()
            self.tableView.selectRow(at: index, animated: true, scrollPosition:UITableViewScrollPosition.none)

            if gestureReconizer.state != UIGestureRecognizerState.ended {
                return
            }
            tableView.deselectRow(at: index, animated: true)
            let itemedit = PartnerEditViewController()
            itemedit.itemModel = PartnerList[index.row]
            self.navigationController?.pushViewController(itemedit, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            PartnerList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let moveitem = PartnerList[sourceIndexPath.row]
        
        PartnerList.remove(at: sourceIndexPath.row)
        PartnerList.insert(moveitem, at: destinationIndexPath.row)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
