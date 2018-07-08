//
//  ViewControllerTwo.swift
//  UITabBarControllerTest
//
//  Created by vip on 16/9/6.
//  Copyright © 2016年 jaki. All rights reserved.
//

import UIKit

class SaleItemEditViewController: UIViewController {

    var ItemNameTextField:UITextField?
    var PriceTextField:UITextField?
    var itemModel = SaleItemModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "売上項目編集"
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
        nameLabel.text = "項目名"
        nameLabel.snp.makeConstraints({ (maker) in
            maker.top.equalTo(10)
            maker.left.equalTo(16)
            maker.width.equalTo(100)
            maker.height.equalTo(40)
        })
        
        ItemNameTextField = UITextField()
        self.view.addSubview(ItemNameTextField!)
        if let nm = itemModel.itemName {
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
        
        let priceLabel = UILabel()
        self.view.addSubview(priceLabel)
        priceLabel.text = "価格"
        priceLabel.snp.makeConstraints({ (maker) in
            maker.top.equalTo(line1.snp.bottom).offset(5)
            maker.left.equalTo(16)
            maker.width.equalTo(100)
            maker.height.equalTo(40)
        })
        
        PriceTextField = UITextField()
        self.view.addSubview(PriceTextField!)
        if let tmp = itemModel.price {
            PriceTextField?.text = String(format: "%d", tmp)
        }
        PriceTextField?.borderStyle = .none
        PriceTextField?.keyboardType = UIKeyboardType.numberPad
        PriceTextField?.returnKeyType = UIReturnKeyType.done
        PriceTextField?.snp.makeConstraints({ (maker) in
            maker.top.equalTo(priceLabel.snp.top)
            maker.left.equalTo(priceLabel.snp.right).offset(1)
            maker.right.equalTo(-16)
            maker.height.equalTo(40)
        })
        
        let line2 = UIView()
        line2.backgroundColor = UIColor.gray
        self.view.addSubview(line2)
        line2.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.equalTo(priceLabel.snp.bottom).offset(5)
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

        itemModel.itemName = self.ItemNameTextField?.text
        itemModel.price = Int32((self.PriceTextField?.text)!)
        if itemModel.itemNo == nil {
            itemModel.itemNo = SaleItemManager.getNextNo()
            SaleItemManager.insert(record: itemModel)
        }
        else {
            SaleItemManager.update(record: itemModel)
        }
        self.navigationController!.popViewController(animated: true)
    }
        
    func checkInput() -> Bool {
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        if self.ItemNameTextField!.text == "" {
            let alertController = UIAlertController(title: nil, message: "項目名が未入力です。", preferredStyle: .alert)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        }

        
        if self.PriceTextField?.text == "" {
            let alertController = UIAlertController(title: nil, message: "価格が未入力です。", preferredStyle: .alert)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        
        return true
    }
}
