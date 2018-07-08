//
//  YearViewController.swift
//  POS
//
//  Created by Yo on 18/3/6.
//  Copyright © 2018年 yo. All rights reserved.
//

import UIKit

class MonViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var monSum = Array<AccSumModel>()
    var Account: AccSumModel?
    var itemView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Account?.accountName
        
        itemView = UITableView(frame: self.view.frame, style: .plain)
        self.view.addSubview(itemView!)
        //リソース設定
        itemView?.delegate = self
        itemView?.dataSource = self
        //定義したcellを登録
        itemView!.register(UINib.init(nibName: "SummaryTableViewCell", bundle: nil), forCellReuseIdentifier: "SummaryCellId")
        installNavigationItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func installNavigationItem() {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadData))
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func loadData(){
        if Account!.debit == 0 {
            monSum = SaleHeadManager.getAccSumByMon(payNo: Account!.accountNo!)
        }
        else{
            monSum = PayManager.getAccSumByMon(accNo: Account!.accountNo!)
        }
        self.itemView!.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return monSum.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SummaryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SummaryCellId", for: indexPath) as! SummaryTableViewCell
        
        let model = monSum[indexPath.row]
        cell.DateItem.text = model.accountName!.substr(start:1, length:4) + "年" + model.accountName!.substr(start:5, length:2) + "月"
        cell.SaleAmount.text = ""
        cell.SaleQty.text = ""
        cell.PayAmount.text = "¥" + Common.formatNumberStr(num: model.amount!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
