//
//  ViewControllerTwo.swift
//  UITabBarControllerTest
//
//  Created by vip on 16/9/6.
//  Copyright © 2016年 jaki. All rights reserved.
//

import UIKit

class PartnerEditViewController: UIViewController {

    var ItemNameTextField:UITextField?
    var itemModel = PartnerModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "支払先登録"
        self.edgesForExtendedLayout = UIRectEdge()
        installUI()
        NavigationItem()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func installUI() {
        let nameLabel = UILabel()
        self.view.addSubview(nameLabel)
        nameLabel.text = "支払先名"
        nameLabel.snp.makeConstraints({ (maker) in
            maker.top.equalTo(10)
            maker.left.equalTo(16)
            maker.width.equalTo(100)
            maker.height.equalTo(40)
        })
        
        ItemNameTextField = UITextField()
        self.view.addSubview(ItemNameTextField!)
        if let nm = itemModel.partnerName {
            ItemNameTextField?.text = nm
        }
        ItemNameTextField?.borderStyle = .none
        ItemNameTextField?.keyboardType = UIKeyboardType.default
        ItemNameTextField?.returnKeyType = UIReturnKeyType.done
        ItemNameTextField?.snp.makeConstraints({ (maker) in
            maker.top.equalTo(nameLabel.snp.top)
            maker.left.equalTo(nameLabel.snp.right).offset(1)
            maker.right.equalTo(-16)
            maker.height.equalTo(40)
        })
        
        let line1 = UIView()
        line1.backgroundColor = UIColor.gray
        self.view.addSubview(line1)
        line1.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.equalTo(nameLabel.snp.bottom).offset(5)
            maker.right.equalTo(0)
            maker.height.equalTo(0.5)
        }

    }
    func NavigationItem() {
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(SaveItem))
        self.navigationItem.rightBarButtonItem = doneButtonItem
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @objc func SaveItem(){
        self.view.endEditing(true)
        if checkInput() == false {
            return
        }

        self.itemModel.partnerName = self.ItemNameTextField?.text
        if self.itemModel.partnerNo == nil {
            self.itemModel.partnerNo = PartnerManager.getNextNo()
            PartnerManager.insert(record: self.itemModel)
        }
        else {
            PartnerManager.update(record: self.itemModel)
        }
        self.navigationController!.popViewController(animated: true)
    }
        
    func checkInput() -> Bool {
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        if self.ItemNameTextField!.text == "" {
            let alertController = UIAlertController(title: nil, message: "支払先名が未入力です。", preferredStyle: .alert)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        
        return true
    }
}
