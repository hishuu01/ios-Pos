//
//  ViewControllerThree.swift
//  UITabBarControllerTest
//
//  Created by vip on 16/9/6.
//  Copyright © 2016年 jaki. All rights reserved.
//

import UIKit

class SumDayViewController: UITableViewController {

    var saleMon: String?
    var saleSum = Array<SummaryModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let yyidx: String.Index = saleMon!.index(saleMon!.startIndex, offsetBy:4)
        self.title = saleMon!.substring(to: yyidx) + "年" + saleMon!.substring(from: yyidx) + "月"
        //定義したcellを登録
        self.tableView.register(UINib.init(nibName: "SummaryTableViewCell", bundle: nil), forCellReuseIdentifier: "SummaryCellId")
        installNavigationItem()
        saleSum = SaleHeadManager.getDaySum(Mon: saleMon!)
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
        saleSum = SaleHeadManager.getDaySum(Mon: saleMon!)
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return saleSum.count
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SummaryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SummaryCellId", for: indexPath) as! SummaryTableViewCell
        
        let model = saleSum[indexPath.row]
        cell.DateItem.text = model.dateStr!.substr(start: 5, length: 2) + "月" + model.dateStr!.substr(start: 7, length: 2) + "日"
        cell.SaleAmount.text = "¥" + Common.formatNumberStr(num: model.saleAmount!)
        cell.SaleQty.text = Common.formatNumberStr(num: model.saleQty!)
        cell.PayAmount.text = "¥" + Common.formatNumberStr(num: model.payAmount!)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = saleSum[indexPath.row]
        let nextview = SaleDayViewController()
        nextview.saleDay = model.dateStr
        self.navigationController?.pushViewController(nextview, animated: true)
    }

}
