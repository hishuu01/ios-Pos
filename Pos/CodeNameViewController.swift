//
//  SaleViewController.swift
//  POS
//
//  Created by Yo on 18/3/6.
//  Copyright © 2018年 yo. All rights reserved.
//

import UIKit

class CodeNameViewController: UITableViewController {
    var viewTitle: String?
    var selectedCode:String?
    var codeList = Array<CodeNameModel>()
    var SetCode:((CodeNameModel)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewTitle!
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //dataArray = DataManager.getGroupData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return codeList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "itemCellID"
        let cell = UITableViewCell(style: .value1, reuseIdentifier: cellID)
        
        let model = codeList[indexPath.row]
        cell.textLabel?.text = model.cdName
        if model.code == self.selectedCode {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = codeList[indexPath.row]
        self.SetCode!(model)
        self.navigationController!.popViewController(animated: true)
    }


}

