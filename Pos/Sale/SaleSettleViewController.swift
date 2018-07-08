//
//  SaleViewController.swift
//  POS
//
//  Created by Yo on 18/3/6.
//  Copyright © 2018年 yo. All rights reserved.
//

import UIKit
import SnapKit
class SaleSettleViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var saleView: SaleViewController?
    var sumQtyLabel: UILabel?
    var sumTotalLabel: UILabel?
    var depositTextField:UITextField?
    var itemCell:UITableView?
    var saleHead = SaleHeadModel()
    var saleDetails = Array<SaleDetailModel>()
    var countArray: Array<Int> = [2,1,1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "決済"
        self.view.tag = 2
        self.view.backgroundColor = UIColor.white
        self.edgesForExtendedLayout = UIRectEdge()
        installUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saleView = self.parent!.parent! as? SaleViewController
        saleHead = saleView!.saleHead
        saleDetails = saleView!.saleDetails
        installNavigationItem()
        DispTotal()
        itemCell?.reloadData()
    }
    
    func installNavigationItem() {
        saleView?.title = self.title
        let inputButtonItem = UIBarButtonItem(title: "売上入力", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.SaleInput))
        saleView!.navigationItem.leftBarButtonItem = inputButtonItem
        let addButtonItem = UIBarButtonItem(title: "項目追加", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.AddItem))
        saleView!.navigationItem.rightBarButtonItems = [addButtonItem]
    }
    
    @objc func SaleInput(){
        saleView!.SaleInput(direct: .reverse)
    }
    
    @objc func AddItem(){
        saleView!.AddItem(direct: .forward)
    }
    
    func installUI() {
        sumQtyLabel = UILabel()
        self.view.addSubview(sumQtyLabel!)
        sumQtyLabel?.font = UIFont.boldSystemFont(ofSize: 32)
        sumQtyLabel?.snp.makeConstraints({ (maker) in
            maker.top.equalTo(10)
            maker.left.equalTo(16)
            maker.width.equalTo(100)
            maker.height.equalTo(40)
        })

        sumTotalLabel = UILabel()
        self.view.addSubview(sumTotalLabel!)
        sumTotalLabel?.textAlignment = NSTextAlignment.right
        sumTotalLabel?.font = UIFont.boldSystemFont(ofSize: 32)
        sumTotalLabel?.snp.makeConstraints({ (maker) in
            maker.top.equalTo(10)
            maker.left.equalTo(sumQtyLabel!.snp.right).offset(1)
            maker.right.equalTo(-10)
            maker.height.equalTo(40)
        })
        
        let line1 = UIView()
        line1.backgroundColor = UIColor.gray
        self.view.addSubview(line1)
        line1.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.equalTo(sumQtyLabel!.snp.bottom).offset(5)
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
        itemCell?.register(UINib.init(nibName: "CashButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "CashButtonTableViewCellId")
    }
    
    func DispTotal(){
        sumQtyLabel?.text = String(format:"%d",saleHead.qty!) + "点"
        sumTotalLabel?.text = Common.formatNumberStr(num:saleHead.total!) + "円"
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
        return 3
    }
    //设置每行数据的数据载体Cell视图
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //获取到载体Cell
        var cell: UITableViewCell?
        
        if indexPath.section == 0 {
            switch (indexPath.row) {
            case 0:
                cell = UITableViewCell(style: .value1, reuseIdentifier: "cellID")
                cell?.textLabel?.text = "決済種別"
                cell?.detailTextLabel?.text = self.saleHead.payName
                cell?.accessoryType = .disclosureIndicator
            case 1:
                let cell1 = tableView.dequeueReusableCell(withIdentifier: "InputTableViewCellId", for: indexPath) as! InputTableViewCell
                cell1.Label.text = "お預り"
                cell1.Label.font = UIFont.systemFont(ofSize: 24)
                cell1.TextField.placeholder = "入金金額"
                cell1.TextField.font = UIFont.systemFont(ofSize: 24)
                cell1.TextField.keyboardType = UIKeyboardType.numberPad
                cell1.TextField.returnKeyType = UIReturnKeyType.done
                depositTextField = cell1.TextField
                return cell1
            default:
                break
            }
        }
        
        if indexPath.section == 1 {
            let cellbtn: CashButtonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CashButtonTableViewCellId", for: indexPath) as! CashButtonTableViewCell
            cellbtn.Button1.setTitle("10000円", for: UIControlState())
            cellbtn.Button1.layer.cornerRadius = 5
            cellbtn.Button1.tag = 10000
            cellbtn.Button1.addTarget(self, action: #selector(addMoney), for: UIControlEvents.touchUpInside)
            cellbtn.Button2.setTitle("5000円", for: UIControlState())
            cellbtn.Button2.layer.cornerRadius = 5
            cellbtn.Button2.tag = 5000
            cellbtn.Button2.addTarget(self, action: #selector(addMoney), for: UIControlEvents.touchUpInside)
            cellbtn.Button3.setTitle("1000円", for: UIControlState())
            cellbtn.Button3.layer.cornerRadius = 5
            cellbtn.Button3.tag = 1000
            cellbtn.Button3.addTarget(self, action: #selector(addMoney), for: UIControlEvents.touchUpInside)
            return cellbtn
        }
        if indexPath.section == 2 {
            let cellbtn: ButtonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCellId", for: indexPath) as! ButtonTableViewCell
            cellbtn.Button.setTitle("登録する", for: UIControlState())
            cellbtn.Button.layer.cornerRadius = 5
            cellbtn.Button.backgroundColor = UIColor(red: 230/255, green: 180/255, blue: 80/255, alpha: 0.5)
            cellbtn.Button.addTarget(self, action: #selector(saveSale), for: UIControlEvents.touchUpInside)
            return cellbtn
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 0 {
            let codeList = CodeNameViewController()
            codeList.viewTitle = "決済種別"
            codeList.codeList = CodeNameManager.find(groupno: "01")
            codeList.selectedCode = self.saleHead.payNo
            codeList.SetCode = {(model:CodeNameModel) in
                self.saleHead.payNo = model.code
                self.saleHead.payName = model.cdName
                self.itemCell?.reloadData()
            }
            self.navigationController?.pushViewController(codeList, animated: true)
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc private func addMoney(sender: UIButton){
        var deposit = Int32((self.depositTextField?.text)!)
        if deposit == nil {
            deposit = 0
        }
        deposit = deposit! + Int32(sender.tag)
        depositTextField?.text = String(format: "%d", deposit!)
        
    }
    
    @objc func saveSale(){
        if checkInput() == false {
            return
        }
        //Head Save
        let now = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyyMMdd"
        saleHead.saleDate = dateformatter.string(from: now)
        dateformatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        saleHead.time = dateformatter.string(from: now)
        saleHead.slipNo = SaleHeadManager.getSlipNo()
        saleHead.payAmount = Int32((self.depositTextField?.text)!)
        saleHead.change = saleHead.payAmount! - saleHead.total!
        SaleHeadManager.insert(head: saleHead)
        
        //Detail Save
        var seq = 1
        for detail in saleDetails {
            detail.slipNo = saleHead.slipNo
            detail.saleDate = saleHead.saleDate
            detail.seq = seq
            SaleDetailManager.insert(detail: detail)
            seq = seq + 1
        }
        //let finish = SaleFinishViewController()
        //finish.saleHead = saleHead
        self.depositTextField?.text = ""
        saleView!.Finish(direct: .forward)
    }
    
    func checkInput() -> Bool {
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        if self.saleHead.qty == 0 {
            let alertController = UIAlertController(title: nil, message: "明細が未登録です。", preferredStyle: .alert)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        if self.saleHead.payNo == nil {
            let alertController = UIAlertController(title: nil, message: "決済種別が未入力です。", preferredStyle: .alert)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        
        if self.depositTextField?.text == "" {
            let alertController = UIAlertController(title: nil, message: "金額が未入力です。", preferredStyle: .alert)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        
        let deposit = Int32((self.depositTextField?.text)!)
        if deposit! < saleHead.total! {
            let alertController = UIAlertController(title: nil, message: "金額が足りません。", preferredStyle: .alert)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        
        return true
    }
}

