//
//  SaleView.swift
//  NoteBook
//
//  Created by yo on 18/3/5.
//  Copyright © 2018年 yo. All rights reserved.
//

import UIKit

class PayDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var payDetails = Array<PayViewModel>()
    var listtableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "本日の出金"
        //定義したcellを登録
        listtableView = UITableView(frame: self.view.frame, style: .plain)
        listtableView?.register(UINib.init(nibName: "PayTableViewCell", bundle: nil), forCellReuseIdentifier: "PayTableViewCellId")
        self.view.addSubview(listtableView!)
        //リソース設定
        listtableView?.delegate = self
        listtableView?.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nowdate = Common.today()
        payDetails = PayManager.getDayPay(payDate: nowdate)
        listtableView?.reloadData()
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return payDetails.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PayTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PayTableViewCellId", for: indexPath) as! PayTableViewCell
        
        let model = payDetails[indexPath.row]
        cell.PartnerName.text = model.partnerName!
        cell.ItemName.text = model.costItemName!
        cell.Amount.text = "¥" + Common.formatNumberStr(num: model.amount!)
        return cell
    }

}

