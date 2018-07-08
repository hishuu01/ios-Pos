//
//  YearViewController.swift
//  POS
//
//  Created by Yo on 18/3/6.
//  Copyright © 2018年 yo. All rights reserved.
//

import UIKit

class YearViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var accSum = Array<AccSumModel>()
    var itemView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "年間集計"
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
        accSum = SaleHeadManager.getAccSum()
        accSum += PayManager.getAccSum()
        self.itemView!.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return accSum.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SummaryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SummaryCellId", for: indexPath) as! SummaryTableViewCell
        
        let model = accSum[indexPath.row]
        cell.DateItem.text = model.accountName!
        cell.SaleAmount.text = ""
        cell.SaleQty.text = ""
        cell.PayAmount.text = "¥" + Common.formatNumberStr(num: model.amount!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = accSum[indexPath.row]
        let nextview = MonViewController()
        nextview.Account = model
        self.navigationController?.pushViewController(nextview, animated: true)
    }
}
