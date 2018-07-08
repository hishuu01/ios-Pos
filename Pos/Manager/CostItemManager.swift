//
//  DataManager.swift
//  NoteBook
//
//  Created by vip on 16/11/11.
//  Copyright © 2016年 jaki. All rights reserved.
//

import UIKit
import SQLiteSwift3
class CostItemManager: NSObject {
    class func insert(record:CostItemModel){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        DataManager.sqlHnadle!.insertData(record.toDictionary(), intoTable: "CostItem")
    }
    
    class func update(record:CostItemModel){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        DataManager.sqlHnadle!.updateData(record.toDictionary(), intoTable: "CostItem", while: "Row=\(record.row!)", isSecurity: false)
    }
    //項目削除
    class func delete(itemNo:String){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        DataManager.sqlHnadle?.deleteData("ItemNo='\(itemNo)'", intoTable: "CostItem", isSecurity: false)
    }
    //項目全削除
    class func deleteAll(){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        DataManager.sqlHnadle?.deleteData("", intoTable: "CostItem", isSecurity: false)
    }
    //項目取得
    class func find(accNo:String = "")->[CostItemModel]{
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        
        let request = SQLiteSearchRequest()
        if accNo != "" {
            request.contidion = "AccountNo='\(accNo)'"
        }
        var array = Array<CostItemModel>()
        DataManager.sqlHnadle?.searchData(withReeuest: request, inTable: "CostItem", searchFinish: { (success, dataArray) in
            dataArray?.forEach({ (element) in
                let record = CostItemModel()
                record.row = element["Row"] as! Int?
                record.itemNo = element["ItemNo"] as! String?
                record.itemName = element["ItemName"] as! String?
                record.accountNo = element["AccountNo"] as! String?
                array.append(record)
            })
        })
        return array
    }
    
    //科目名つき支払科目一覧
    class func findWithAccName()->[CostItemViewModel]{
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        
        let sql = "select a.Row, a.ItemNo, a.ItemName, a.AccountNo, b.AccountName from CostItem as a left join Account as b on a.AccountNo = b.AccountNo"
        let fiels:Array<String> = ["Row", "ItemNo", "ItemName", "AccountNo", "AccountName"]
        var array = Array<CostItemViewModel>()
        DataManager.sqlHnadle?.runSelectSQL(sql, selectField: fiels, searchFinish: { (success, dataArray) in
            dataArray?.forEach({ (element) in
                let record = CostItemViewModel()
                record.row = Int((element["Row"] as! String?)!)
                record.itemNo = element["ItemNo"] as! String?
                record.itemName = element["ItemName"] as! String?
                if element["AccountNo"] as! String? == "NULL" {
                    record.accountNo = ""
                }
                else{
                    record.accountNo = element["AccountNo"] as! String?
                }
                let tmp = element["AccountName"] as! String?
                if tmp == "NULL" {
                    record.accountName = "未定義"
                }
                else{
                    record.accountName = tmp
                }
                array.append(record)
            })
        })
        return array
    }
    class func createTable(){
        let row = SQLiteKeyObject()
        row.name = "Row"
        row.fieldType = INTEGER
        row.modificationType = PRIMARY_KEY
        
        let itemNo = SQLiteKeyObject()
        itemNo.name = "ItemNo"
        itemNo.fieldType = TEXT

        let itemName = SQLiteKeyObject()
        itemName.name = "ItemName"
        itemName.fieldType = TEXT
        
        let accountNo = SQLiteKeyObject()
        accountNo.name = "AccountNo"
        accountNo.fieldType = TEXT
        
        DataManager.sqlHnadle!.createTable(withName: "CostItem", keys: [row, itemNo, itemName, accountNo])
        
    }
    
    class func sampleData(){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        let data = CostItemModel()
        
        data.itemNo = "001"
        data.itemName = "電気代"
        data.accountNo = "1101"
        self.insert(record: data)

        data.itemNo = "002"
        data.itemName = "交通費"
        data.accountNo = "1102"
        self.insert(record: data)

        data.itemNo = "003"
        data.itemName = "家賃"
        data.accountNo = "1103"
        self.insert(record: data)
    }


}
