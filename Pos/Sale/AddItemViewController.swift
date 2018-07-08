//
//  SaleViewController.swift
//  POS
//
//  Created by Yo on 18/3/6.
//  Copyright © 2018年 yo. All rights reserved.
//

import UIKit
import SnapKit
class AddItemViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var saleView: SaleViewController?
    var sumQtyLabel:UILabel?
    var sumTotalLabel:UILabel?
    var PriceTextField:UITextField?
    var QtyTextField:UITextField?
    var itemCell:UITableView?
    var saveSwi:UISwitch?
    var saleHead = SaleHeadModel()
    var saleDetail = SaleDetailModel()
    var countArray: Array<Int> = [4,1,1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "項目追加"
        self.view.tag = 0
        self.view.backgroundColor = UIColor.white
        self.edgesForExtendedLayout = UIRectEdge()
        installUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saleView = self.parent!.parent! as? SaleViewController
        saleHead = saleView!.saleHead
        installNavigationItem()
        DispTotal()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func installNavigationItem() {
        saleView?.title = self.title
        //let sumButtonItem = UIBarButtonItem(title: "小計", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.SettleMent))
        //sumButtonItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 16)], for: .normal)
        let sumbtn = UIButton()
        sumbtn.setTitle("小計", for: .normal)
        sumbtn.setTitleColor(saleView?.navigationController?.navigationBar.tintColor, for: .normal)
        sumbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        sumbtn.addTarget(self, action: #selector(self.SettleMent), for: UIControlEvents.touchUpInside)
        let sumButtonItem = UIBarButtonItem(customView: sumbtn)
        saleView!.navigationItem.leftBarButtonItem = sumButtonItem
        let inputButtonItem = UIBarButtonItem(title: "売上入力", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.SaleInput))
        saleView!.navigationItem.rightBarButtonItems = [inputButtonItem]
    }
    
    @objc func SettleMent(){
        saleView!.SettleMent(direct: .reverse)
    }
    
    @objc func SaleInput(){
        saleView!.SaleInput(direct: .forward)
    }
    
    
    func installUI() {
        sumQtyLabel = UILabel()
        self.view.addSubview(sumQtyLabel!)
        sumQtyLabel?.font = UIFont.boldSystemFont(ofSize: 32)
        sumQtyLabel?.text = "0点"
        sumQtyLabel?.snp.makeConstraints({ (maker) in
            maker.top.equalTo(10)
            maker.left.equalTo(16)
            maker.width.equalTo(100)
            maker.height.equalTo(40)
        })

        sumTotalLabel = UILabel()
        self.view.addSubview(sumTotalLabel!)
        sumTotalLabel?.text = "0円"
        sumTotalLabel?.textAlignment = NSTextAlignment.right
        sumTotalLabel?.font = UIFont.boldSystemFont(ofSize: 32)
        sumTotalLabel?.snp.makeConstraints({ (maker) in
            maker.top.equalTo(10)
            maker.left.equalTo(sumQtyLabel!.snp.right).offset(1)
            maker.right.equalTo(-10)
            maker.height.equalTo(40)
        })
        //タップイベント追加
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.userClick(sender:)))
        sumTotalLabel?.isUserInteractionEnabled = true
        sumTotalLabel?.addGestureRecognizer(tapGesture)
        
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
        self.view.addSubview(itemCell!)
        itemCell?.snp.makeConstraints({ (maker) in
            maker.top.equalTo(line1.snp.bottom).offset(5)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        })
        itemCell?.register(UINib.init(nibName: "InputTableViewCell", bundle: nil), forCellReuseIdentifier: "InputTableViewCellId")
        itemCell?.register(UINib.init(nibName: "SelectTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectTableViewCellId")
        itemCell?.register(UINib.init(nibName: "ButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "ButtonTableViewCellId")
        
        let scanButton =  UIButton(type: UIButtonType.system)
        scanButton.tintColor = UIColor.black
        scanButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        scanButton.backgroundColor = UIColor.yellow

        scanButton.setTitle("スキャン", for: UIControlState())
        self.view.addSubview(scanButton)
        scanButton.snp.makeConstraints { (maker) in
            maker.width.equalTo(60)
            maker.height.equalTo(60)
            maker.centerX.equalTo(self.view)
            maker.bottom.equalTo(0)
        }
        scanButton.layer.cornerRadius = 30
        
        scanButton.addTarget(self, action: #selector(self.scanCode), for: UIControlEvents.touchUpInside)
    }
    
    @objc private func userClick(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        let detailList = SaleDetailViewController()
        detailList.saleDetails = self.saleView!.saleDetails
        detailList.setDetail = {(list:Array<SaleDetailModel>) in
            self.saleView!.saleDetails = list
            self.CalcTotal()
            self.DispTotal()
        }
        self.navigationController?.pushViewController(detailList, animated: true)
        
    }
    
    @objc func scanCode() {
        self.view.endEditing(true)
        let detailList = ScanViewController()
        detailList.setDetail = {(result:SaleDetailModel) in
            self.saleDetail = result
            self.saleView!.saleDetails.append(self.saleDetail)
            self.saleHead.qty = self.saleHead.qty! + self.saleDetail.qty!
            self.saleHead.total = self.saleHead.total! + self.saleDetail.total!
            self.DispTotal()
        }
        self.navigationController?.pushViewController(detailList, animated: true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func switchDidChange(){
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
                cell?.textLabel?.text = "項目"
                cell?.detailTextLabel?.text = self.saleDetail.itemName
                cell?.accessoryType = .disclosureIndicator
            case 1:
                let cell1 = tableView.dequeueReusableCell(withIdentifier: "InputTableViewCellId", for: indexPath) as! InputTableViewCell
                cell1.Label.text = "金額"
                cell1.TextField.placeholder = "単価"
                cell1.TextField.keyboardType = UIKeyboardType.numberPad
                cell1.TextField.returnKeyType = UIReturnKeyType.done
                if let price = self.saleDetail.price {
                    cell1.TextField.text = String(format: "%d", price)
                }
                PriceTextField = cell1.TextField
                return cell1
            case 2:
                let cell2 = tableView.dequeueReusableCell(withIdentifier: "InputTableViewCellId", for: indexPath) as! InputTableViewCell
                cell2.Label.text = "点数"
                cell2.TextField.placeholder = "数量"
                cell2.TextField.keyboardType = UIKeyboardType.numberPad
                cell2.TextField.returnKeyType = UIReturnKeyType.done
                if let qty = self.saleDetail.qty {
                    cell2.TextField.text = String(format: "%d", qty)
                }
                else {
                    cell2.TextField.text  = "1"
                }
                QtyTextField = cell2.TextField
                return cell2
            case 3:
                let cell3 = tableView.dequeueReusableCell(withIdentifier: "SelectTableViewCellId", for: indexPath) as! SelectTableViewCell
                cell3.Label.text = "ひな形にも追加する"
                cell3.SwitchField.isOn = true
                cell3.SwitchField.addTarget(self, action: #selector(switchDidChange),for:UIControlEvents.valueChanged)
                saveSwi = cell3.SwitchField
                return cell3
            default:
                break
            }
        }
        
        if indexPath.section == 1 {
            let cellbtn: ButtonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCellId", for: indexPath) as! ButtonTableViewCell
            cellbtn.Button.setTitle("追加する", for: UIControlState())
            cellbtn.Button.layer.cornerRadius = 5
            cellbtn.Button.backgroundColor = UIColor(red: 230/255, green: 180/255, blue: 80/255, alpha: 0.5)
            cellbtn.Button.addTarget(self, action: #selector(AddDetail), for: UIControlEvents.touchUpInside)
            return cellbtn
        }
        
        if indexPath.section == 2 {
            let cellbtn: ButtonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCellId", for: indexPath) as! ButtonTableViewCell
            cellbtn.Button.setTitle("ひな形のみに追加する", for: UIControlState())
            cellbtn.Button.setTitleColor(UIColor.red, for: UIControlState())
            cellbtn.Button.layer.borderWidth = 0.5
            cellbtn.Button.layer.cornerRadius = 5
            cellbtn.Button.addTarget(self, action: #selector(AddTemp), for: UIControlEvents.touchUpInside)
            return cellbtn
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 0 {
            let itemList = ItemListViewController()
            itemList.ItemNo = self.saleDetail.itemNo
            itemList.selectItem = {(model:SaleItemModel) in
                self.saleDetail.itemNo = model.itemNo
                self.saleDetail.itemName = model.itemName
                self.PriceTextField?.text = String(format: "%d", model.price!)
                self.itemCell?.reloadData()
            }
            self.navigationController?.pushViewController(itemList, animated: true)
        }
    }

    func getInput() -> Bool {
        self.view.endEditing(true)
        if checkInput() == false {
            return false
        }
        saleDetail.price = Int32((self.PriceTextField?.text)!)
        saleDetail.qty = Int32((self.QtyTextField?.text)!)
        saleDetail.total = saleDetail.price! * saleDetail.qty!
        return true
    }
    
    @objc func AddDetail(){
        if getInput() == false {
            return
        }
        
        saleView!.saleDetails.append(saleDetail)
        saleHead.qty = saleHead.qty! + saleDetail.qty!
        saleHead.total = saleHead.total! + saleDetail.total!
        DispTotal()

        if saveSwi!.isOn == true {
            SaveTemp()
        }
        //入力エリアクリア
        //InputClear()
    }
    
    func SaveTemp(){
        let retmodel: SaleHistoryModel = SaleHistoryManager.find(itemNo: saleDetail.itemNo!, price: saleDetail.price!)
        if retmodel.itemNo == nil {
            let salehistory = SaleHistoryModel()
            salehistory.itemNo = saleDetail.itemNo
            salehistory.itemName = saleDetail.itemName
            salehistory.price = saleDetail.price
            salehistory.qty = saleDetail.qty
            salehistory.total = saleDetail.total
            SaleHistoryManager.insert(detail: salehistory)
        }
    }
    
    
    @objc func AddTemp(){
        if getInput() == false {
            return
        }
        SaveTemp()
        //入力エリアクリア
        InputClear()
    }
    
    
    func InputClear(){
        saleDetail = SaleDetailModel()
        self.itemCell?.reloadData()
        self.PriceTextField?.text = ""
        self.QtyTextField?.text = "1"
    }
    
    func CalcTotal(){
        saleHead.qty = 0
        saleHead.total = 0
        for detail : SaleDetailModel in saleView!.saleDetails{
            saleHead.qty = saleHead.qty! + detail.qty!
            saleHead.total = saleHead.total! + detail.total!
        }
    }
    
    func DispTotal(){
        sumQtyLabel?.text = String(format:"%d",saleHead.qty!) + "点"
        sumTotalLabel?.text = Common.formatNumberStr(num:saleHead.total!) + "円"
    }
    
    func setDetail(model: SaleHistoryModel) {
        self.saleDetail.itemNo = model.itemNo
        self.saleDetail.itemName = model.itemName
        self.saleDetail.price = model.price
        self.saleDetail.qty = model.qty
    }

    func checkInput() -> Bool {
        var ret: Bool = true
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
            ret = false
        }
        
        if self.saleDetail.itemNo == nil {
            let alertController = UIAlertController(title: nil, message: "項目が選択されていません。", preferredStyle: .alert)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        
        if self.PriceTextField?.text == "" {
            let alertController = UIAlertController(title: nil, message: "単価が未入力です。", preferredStyle: .alert)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        if self.QtyTextField?.text == "" {
            let alertController = UIAlertController(title: nil, message: "数量が未入力です。", preferredStyle: .alert)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        }

        if Int32((self.QtyTextField?.text)!) == 0 {
            let alertController = UIAlertController(title: nil, message: "数量が1以上必要です。", preferredStyle: .alert)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            ret = false
            return false
        }

        return ret
    }
}

