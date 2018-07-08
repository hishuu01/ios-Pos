//
//  ViewControllerTwo.swift
//  UITabBarControllerTest
//
//  Created by vip on 16/9/6.
//  Copyright © 2016年 jaki. All rights reserved.
//

import UIKit

class CostItemEditViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var ItemNameTextField:UITextField?
    var AccCell: UITableView?
    var itemModel = CostItemViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "支払項目編集"
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
        
        AccCell = UITableView()
        AccCell?.delegate = self
        AccCell?.dataSource = self
        AccCell?.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(AccCell!)
        AccCell?.snp.makeConstraints({ (maker) in
            maker.top.equalTo(line1.snp.bottom).offset(5)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.height.equalTo(40)
        })
        
        let line2 = UIView()
        line2.backgroundColor = UIColor.gray
        self.view.addSubview(line2)
        line2.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.equalTo(AccCell!.snp.bottom).offset(5)
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
        let model = CostItemModel()
        if itemModel.itemNo == nil {
            model.row = nil
            model.itemNo = SaleItemManager.getNextNo()
            model.itemName = itemModel.itemName
            model.accountNo = itemModel.accountNo
            CostItemManager.insert(record: model)
        }
        else {
            model.row = itemModel.row
            model.itemNo = itemModel.itemNo
            model.itemName = itemModel.itemName
            model.accountNo = itemModel.accountNo
            CostItemManager.update(record: model)
        }
        self.navigationController!.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    //设置列表有多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //设置列表的分区数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //设置每行数据的数据载体Cell视图
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //获取到载体Cell
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cellID")
        cell.textLabel?.text = "該当科目"
        cell.detailTextLabel?.text = self.itemModel.accountName
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
        let selectView = CodeNameViewController()
        selectView.viewTitle = "該当科目"
        var itemlist = Array<CodeNameModel>()
        let list = AccountManager.find()
        for item: AccountModel in list {
            let cdnm = CodeNameModel()
            cdnm.code = item.accountNo
            cdnm.cdName = item.accountName
            itemlist.append(cdnm)
        }
        selectView.codeList = itemlist
        selectView.selectedCode = self.itemModel.accountNo
        selectView.SetCode = {(model:CodeNameModel) in
            self.itemModel.accountNo = model.code
            self.itemModel.accountName = model.cdName
            self.AccCell?.reloadData()
        }
        self.navigationController?.pushViewController(selectView, animated: true)
    }
    
    func checkInput() -> Bool {
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        if self.ItemNameTextField!.text == "" {
            let alertController = UIAlertController(title: nil, message: "項目名が未入力です。", preferredStyle: .alert)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        
        return true
    }
}
