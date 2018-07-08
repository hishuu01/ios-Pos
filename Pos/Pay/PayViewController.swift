//
//  ViewControllerTwo.swift
//  UITabBarControllerTest
//
//  Created by vip on 16/9/6.
//  Copyright © 2016年 jaki. All rights reserved.
//

import UIKit

class PayViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var amountSum: Int32?
    var amountSumLabel:UILabel?
    var itemCell: UITableView?
    var AmountTextField:UITextField?
    var itemCode = Array<CodeNameModel>()
    var pay = PayModel()
    var countArray: Array<Int> = [3,1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "出金入力"
        self.edgesForExtendedLayout = UIRectEdge()
        
        var item: CodeNameModel
        item = CodeNameModel()
        item.groupName = "支払先"
        item.code = ""
        item.cdName = ""
        itemCode.append(item)
        
        item = CodeNameModel()
        item.groupName = "支払項目"
        item.code = ""
        item.cdName = ""
        itemCode.append(item)
        installUI()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let now = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyyMMdd"
        let nowdate = dateformatter.string(from: now)
        amountSum = PayManager.getDaySum(payDate: nowdate)
        amountSumLabel?.text = Common.formatNumberStr(num:amountSum!) + "円"
    }
    
    func installUI() {
        let sumLabel = UILabel()
        self.view.addSubview(sumLabel)
        sumLabel.text = "本日の出金"
        sumLabel.snp.makeConstraints({ (maker) in
            maker.top.equalTo(10)
            maker.left.equalTo(16)
            maker.width.equalTo(100)
            maker.height.equalTo(40)
        })
        
        amountSumLabel = UILabel()
        self.view.addSubview(amountSumLabel!)
        amountSumLabel?.text = "0円"
        amountSumLabel?.textAlignment = NSTextAlignment.right
        amountSumLabel?.font = UIFont.boldSystemFont(ofSize: 32)
        amountSumLabel?.snp.makeConstraints({ (maker) in
            maker.top.equalTo(10)
            maker.left.equalTo(sumLabel.snp.right).offset(1)
            maker.right.equalTo(-10)
            maker.height.equalTo(40)
        })
        //タップイベント追加
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.userClick(sender:)))
        amountSumLabel?.isUserInteractionEnabled = true
        amountSumLabel?.addGestureRecognizer(tapGesture)
        
        let line1 = UIView()
        line1.backgroundColor = UIColor.gray
        self.view.addSubview(line1)
        line1.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.equalTo(amountSumLabel!.snp.bottom).offset(5)
            maker.right.equalTo(0)
            maker.height.equalTo(0.5)
        }
        
        
        itemCell = UITableView()
        self.view.addSubview(itemCell!)
        itemCell?.delegate = self
        itemCell?.dataSource = self
        //itemCell?.separatorStyle = UITableViewCellSeparatorStyle.none
        itemCell?.snp.makeConstraints({ (maker) in
            maker.top.equalTo(line1.snp.bottom).offset(5)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        })
        itemCell?.register(UINib.init(nibName: "InputTableViewCell", bundle: nil), forCellReuseIdentifier: "InputTableViewCellId")
        itemCell?.register(UINib.init(nibName: "ButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "ButtonTableViewCellId")
    }
    
    @objc private func userClick(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        let detailList = PayDetailViewController()
        self.navigationController?.pushViewController(detailList, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 20
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        }
        return " "
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    //设置列表有多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countArray[section]
    }
    
    //设置列表的分区数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    //设置每行数据的数据载体Cell视图
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //获取到载体Cell
        var cell: UITableViewCell?
        if indexPath.section == 0 {
            if indexPath.row < 2 {
                cell = UITableViewCell(style: .value1, reuseIdentifier: "cellID")
                let model = itemCode[indexPath.row]
                cell?.textLabel?.text = model.groupName
                cell?.detailTextLabel?.text = model.cdName
                cell?.accessoryType = .disclosureIndicator
            }
            else{
                let cell2 = tableView.dequeueReusableCell(withIdentifier: "InputTableViewCellId", for: indexPath) as! InputTableViewCell
                cell2.Label.text = "金額"
                cell2.TextField.placeholder = "出金額"
                cell2.TextField.keyboardType = UIKeyboardType.numberPad
                cell2.TextField.returnKeyType = UIReturnKeyType.done
                AmountTextField = cell2.TextField
                return cell2
            }
        }
        if indexPath.section == 1 {
            let cellbtn: ButtonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCellId", for: indexPath) as! ButtonTableViewCell
            cellbtn.Button.setTitle("登録する", for: UIControlState())
            cellbtn.Button.setTitleColor(UIColor.red, for: UIControlState())
            cellbtn.Button.backgroundColor = UIColor(red: 230/255, green: 180/255, blue: 80/255, alpha: 0.5)
            cellbtn.Button.layer.cornerRadius = 5
            cellbtn.Button.addTarget(self, action: #selector(SavePay), for: UIControlEvents.touchUpInside)
            return cellbtn
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row != 2 {
            let item = itemCode[indexPath.row]
            let selectView = CodeNameViewController()
            selectView.viewTitle = item.groupName
            var itemlist = Array<CodeNameModel>()
            if indexPath.row == 0 {
                let list = PartnerManager.find()
                for partner: PartnerModel in list {
                    let cdnm = CodeNameModel()
                    cdnm.code = partner.partnerNo
                    cdnm.cdName = partner.partnerName
                    itemlist.append(cdnm)
                }
            }
            if indexPath.row == 1 {
                let list = CostItemManager.find()
                for costItem: CostItemModel in list {
                    let cdnm = CodeNameModel()
                    cdnm.code = costItem.itemNo
                    cdnm.cdName = costItem.itemName
                    itemlist.append(cdnm)
                }
            }
            selectView.codeList = itemlist
            selectView.selectedCode = item.code
            selectView.SetCode = {(model:CodeNameModel) in
                item.code = model.code
                item.cdName = model.cdName
                self.itemCell?.reloadData()
            }
            self.navigationController?.pushViewController(selectView, animated: true)
        }
    }
    @objc func SavePay(){
            self.view.endEditing(true)
            if checkInput() == false {
                return
            }
            let now = Date()
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyyMMdd"
            pay.payDate = dateformatter.string(from: now)
            dateformatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            pay.time = dateformatter.string(from: now)
            pay.partnerNo = itemCode[0].code
            pay.costItemNo = itemCode[1].code
            pay.amount = Int32((self.AmountTextField?.text)!)
            PayManager.insert(record: pay)
            
            amountSum = amountSum! + pay.amount!
            amountSumLabel?.text = Common.formatNumberStr(num:amountSum!) + "円"
            //clear display
            itemCode[0].code = ""
            itemCode[0].cdName = ""
            itemCode[1].code = ""
            itemCode[1].cdName = ""
            AmountTextField?.text = ""
            itemCell?.reloadData()
        }
        
        func checkInput() -> Bool {
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            if itemCode[0].code == "" {
                let alertController = UIAlertController(title: nil, message: "支払先が未入力です。", preferredStyle: .alert)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                return false
            }
            
            if itemCode[1].code == "" {
                let alertController = UIAlertController(title: nil, message: "支払項目が未入力です。", preferredStyle: .alert)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                return false
            }
            
            if self.AmountTextField?.text == "" {
                let alertController = UIAlertController(title: nil, message: "出金金額が未入力です。", preferredStyle: .alert)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                return false
            }
            
            let num = Int32((self.AmountTextField?.text)!)
            if num! < 1 {
                let alertController = UIAlertController(title: nil, message: "1以上金額を入力して下さい。", preferredStyle: .alert)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                return false
            }
            
            return true
        }
}
