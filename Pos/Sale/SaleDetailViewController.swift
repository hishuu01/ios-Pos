//
//  SaleView.swift
//  NoteBook
//
//  Created by yo on 18/3/5.
//  Copyright © 2018年 yo. All rights reserved.
//

import UIKit

class SaleDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var saleDetails = Array<SaleDetailModel>()
    var setDetail:((Array<SaleDetailModel>)->Void)?
    var listtableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "売上明細"
        //定義したcellを登録
        listtableView = UITableView(frame: self.view.frame, style: .plain)
        listtableView?.register(UINib.init(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "SaleTableViewCellId")
        self.view.addSubview(listtableView!)
        //リソース設定
        listtableView?.delegate = self
        listtableView?.dataSource = self
        
        EditNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //dataArray = DataManager.getGroupData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func EditNavigationItem() {
        let barButtonItem = UIBarButtonItem(title: "編集", style: UIBarButtonItemStyle.plain, target: self, action: #selector(EntryEdit))
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    func FinishNavigationItem() {
        let barButtonItem = UIBarButtonItem(title: "完了", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ExitEdit))
        self.navigationItem.rightBarButtonItem = barButtonItem
    }

    @objc func EntryEdit() {
        listtableView?.isEditing = true
        FinishNavigationItem()
    }

    @objc func ExitEdit() {
        listtableView?.isEditing = false
        self.setDetail!(saleDetails)
        EditNavigationItem()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return saleDetails.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SaleTableViewCellId", for: indexPath) as! DetailTableViewCell
        
        let model = saleDetails[indexPath.row]
        cell.ItemName.text = model.itemName!
        cell.price.text = Common.formatNumberStr(num: model.price!)
        cell.qty.text = Common.formatNumberStr(num: model.qty!)
        cell.total.text = Common.formatNumberStr(num: model.total!)
        return cell
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            saleDetails.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
        }
        
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let moveitem = saleDetails[sourceIndexPath.row]

        saleDetails.remove(at: sourceIndexPath.row)
        saleDetails.insert(moveitem, at: destinationIndexPath.row)
        
    }

}

