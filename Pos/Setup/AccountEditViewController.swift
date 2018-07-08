//
//  ViewControllerTwo.swift
//  UITabBarControllerTest
//
//  Created by vip on 16/9/6.
//  Copyright © 2016年 jaki. All rights reserved.
//

import UIKit

class AccountEditViewController: UIViewController {

    var AccNoTextField:UITextField?
    var AccNameTextField:UITextField?
    var itemModel = AccountModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "会計科目編集"
        self.edgesForExtendedLayout = UIRectEdge()
        installUI()
        NavigationItem()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func installUI() {
        let AccNoLabel = UILabel()
        self.view.addSubview(AccNoLabel)
        AccNoLabel.text = "科目コード"
        AccNoLabel.snp.makeConstraints({ (maker) in
            maker.top.equalTo(10)
            maker.left.equalTo(16)
            maker.width.equalTo(100)
            maker.height.equalTo(40)
        })
        
        AccNoTextField = UITextField()
        self.view.addSubview(AccNoTextField!)
        if let no = itemModel.accountNo {
            AccNoTextField?.text = no
            AccNoTextField?.isEnabled = false
            AccNoTextField?.textColor = UIColor.gray
        }
        AccNoTextField?.borderStyle = .none
        AccNoTextField?.keyboardType = UIKeyboardType.numberPad
        AccNoTextField?.returnKeyType = UIReturnKeyType.done
        AccNoTextField?.snp.makeConstraints({ (maker) in
            maker.top.equalTo(AccNoLabel.snp.top)
            maker.left.equalTo(AccNoLabel.snp.right).offset(1)
            maker.right.equalTo(-16)
            maker.height.equalTo(40)
        })
        
        let line1 = UIView()
        line1.backgroundColor = UIColor.gray
        self.view.addSubview(line1)
        line1.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.equalTo(AccNoLabel.snp.bottom).offset(5)
            maker.right.equalTo(0)
            maker.height.equalTo(0.5)
        }
        
        let AccNameLabel = UILabel()
        self.view.addSubview(AccNameLabel)
        AccNameLabel.text = "科目名称"
        AccNameLabel.snp.makeConstraints({ (maker) in
            maker.top.equalTo(line1.snp.bottom).offset(5)
            maker.left.equalTo(16)
            maker.width.equalTo(100)
            maker.height.equalTo(40)
        })
        
        AccNameTextField = UITextField()
        self.view.addSubview(AccNameTextField!)
        if let nm = itemModel.accountName {
            AccNameTextField?.text = nm
        }
        AccNameTextField?.borderStyle = .none
        AccNameTextField?.keyboardType = UIKeyboardType.default
        AccNameTextField?.returnKeyType = UIReturnKeyType.done
        AccNameTextField?.snp.makeConstraints({ (maker) in
            maker.top.equalTo(AccNameLabel.snp.top)
            maker.left.equalTo(AccNameLabel.snp.right).offset(1)
            maker.right.equalTo(-16)
            maker.height.equalTo(40)
        })
        
        let line2 = UIView()
        line2.backgroundColor = UIColor.gray
        self.view.addSubview(line2)
        line2.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.equalTo(AccNameLabel.snp.bottom).offset(5)
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
        self.itemModel.accountNo = self.AccNoTextField?.text
        self.itemModel.accountName = self.AccNameTextField?.text
        if self.itemModel.row == nil {
            AccountManager.insert(record: self.itemModel)
        }
        else {
            AccountManager.update(record: self.itemModel)
        }
        self.navigationController!.popViewController(animated: true)
    }
        
    func checkInput() -> Bool {
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        if self.itemModel.row == nil {
            if self.AccNoTextField!.text == "" {
                let alertController = UIAlertController(title: nil, message: "科目コードが未入力です。", preferredStyle: .alert)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                return false
            }
            let array = AccountManager.find(accountNo: self.AccNoTextField!.text!)
            if array.count > 0 {
                let alertController = UIAlertController(title: nil, message: "科目コードが重複しています。", preferredStyle: .alert)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                return false
            }
        }
    
        if self.AccNameTextField!.text == "" {
            let alertController = UIAlertController(title: nil, message: "科目名称が未入力です。", preferredStyle: .alert)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        
        let array2 = AccountManager.findByName(accNo: self.AccNoTextField!.text!, accName: self.AccNameTextField!.text!)
        if array2.count > 0 {
            let alertController = UIAlertController(title: nil, message: "科目名称が重複しています。", preferredStyle: .alert)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
}
