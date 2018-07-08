//
//  ViewControllerThree.swift
//  UITabBarControllerTest
//
//  Created by vip on 16/9/6.
//  Copyright © 2016年 jaki. All rights reserved.
//

import UIKit

class SaleDayViewController: UITableViewController {

    var saleDay: String?
    var saleList = Array<SaleHeadModel>()
    var payList = Array<PayViewModel>()
    var accountSum = Array<AccSumModel>()
    var sectionTitle: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = saleDay!.substr(start: 5, length: 2) + "月" + saleDay!.substr(start: 7, length: 2) + "日"
        //self.tableView = .grouped
        //定義したcellを登録
        self.tableView.register(UINib.init(nibName: "SummaryTableViewCell", bundle: nil), forCellReuseIdentifier: "SummaryCellId")
        self.tableView.register(UINib.init(nibName: "PayTableViewCell", bundle: nil), forCellReuseIdentifier: "PayTableViewCellId")
        sectionTitle = ["売上","出金","会計科目"]
        installNavigationItem()
        saleList = SaleHeadManager.getDaySale(saleDate: saleDay!)
        payList = PayManager.getDayPay(payDate: saleDay!)
        accountSum = PayManager.getSumByAccount(payDate: saleDay!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //dataArray = DataManager.getGroupData()
    }
    
    func installNavigationItem() {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reload))
        self.navigationItem.rightBarButtonItem = barButtonItem
    }

    @objc func reload(){
        saleList = SaleHeadManager.getDaySale(saleDate: saleDay!)
        payList = PayManager.getDayPay(payDate: saleDay!)
        accountSum = PayManager.getSumByAccount(payDate: saleDay!)
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle![section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int?
        
        switch section {
        case 0:
            count = saleList.count
        case 1:
            count = payList.count
        case 2:
            count = accountSum.count
        default:
            count = 0
        }
        return count!
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var retcell: UITableViewCell?
        
        if indexPath.section == 0 {
            let cell: SummaryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SummaryCellId", for: indexPath) as! SummaryTableViewCell
            let model = saleList[indexPath.row]
            cell.DateItem.text = model.slipNo
            cell.SaleAmount.text = ""
            cell.SaleQty.text = Common.formatNumberStr(num: model.qty!)
            cell.PayAmount.text = "¥" + Common.formatNumberStr(num: model.total!)
            retcell = cell
        }
        else{
            let cell: PayTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PayTableViewCellId", for: indexPath) as! PayTableViewCell
            if indexPath.section == 1 {
                let model = payList[indexPath.row]
                cell.PartnerName.text = model.partnerName!
                cell.ItemName.text = model.costItemName!
                cell.Amount.text = "¥" + Common.formatNumberStr(num: model.amount!)
            }
            else{
                let model = accountSum[indexPath.row]
                cell.PartnerName.text = model.accountName!
                cell.ItemName.text = ""
                cell.Amount.text = "¥" + Common.formatNumberStr(num: model.amount!)
            }
            retcell = cell
        }
        return retcell!
    }
}
