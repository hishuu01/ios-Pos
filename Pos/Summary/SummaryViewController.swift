//
//  ViewControllerThree.swift
//  UITabBarControllerTest
//
//  Created by vip on 16/9/6.
//  Copyright © 2016年 jaki. All rights reserved.
//

import UIKit

class SummaryViewController: UITableViewController {

    var saleSum = Array<SummaryModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "月日集計"
        //定義したcellを登録
        self.tableView.register(UINib.init(nibName: "SummaryTableViewCell", bundle: nil), forCellReuseIdentifier: "SummaryCellId")
        installNavigationItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saleSum = SaleHeadManager.getMonSum()
        self.tableView.reloadData()
    }
    
    func installNavigationItem() {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reload))
        self.navigationItem.rightBarButtonItem = barButtonItem
    }

    @objc func reload(){
        saleSum = SaleHeadManager.getMonSum()
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
        let yyidx: String.Index = model.dateStr!.index(model.dateStr!.startIndex, offsetBy:4)
        cell.DateItem.text = model.dateStr!.substring(to: yyidx) + "年" + model.dateStr!.substring(from: yyidx) + "月"
        cell.SaleAmount.text = "¥" + Common.formatNumberStr(num: model.saleAmount!)
        cell.SaleQty.text = Common.formatNumberStr(num: model.saleQty!)
        cell.PayAmount.text = "¥" + Common.formatNumberStr(num: model.payAmount!)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = saleSum[indexPath.row]
        let nextview = SumDayViewController()
        nextview.saleMon = model.dateStr
        self.navigationController?.pushViewController(nextview, animated: true)
    }

}
