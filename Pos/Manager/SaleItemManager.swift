//
//  DataManager.swift
//  NoteBook
//
//  Created by vip on 16/11/11.
//  Copyright © 2016年 jaki. All rights reserved.
//

import UIKit
import SQLiteSwift3
class SaleItemManager: NSObject {
    class func insert(record:SaleItemModel){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        DataManager.sqlHnadle!.insertData(record.toDictionary(), intoTable: "SaleItem")
    }
    
    class func update(record:SaleItemModel){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        DataManager.sqlHnadle!.updateData(record.toDictionary(), intoTable: "SaleItem", while: "Row=\(record.row!)", isSecurity: false)
    }
    //項目削除
    class func delete(itemNo:String){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        DataManager.sqlHnadle?.deleteData("ItemNo='\(itemNo)'", intoTable: "SaleItem", isSecurity: false)
    }
    //項目全削除
    class func deleteAll(){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        DataManager.sqlHnadle?.deleteData("", intoTable: "SaleItem", isSecurity: false)
    }
    //全項目取得
    class func find()->[SaleItemModel]{
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        
        let request = SQLiteSearchRequest()
        var array = Array<SaleItemModel>()
        DataManager.sqlHnadle?.searchData(withReeuest: request, inTable: "SaleItem", searchFinish: { (success, dataArray) in
            dataArray?.forEach({ (element) in
                let record = SaleItemModel()
                record.row = element["Row"] as! Int?
                record.itemNo = element["ItemNo"] as! String?
                record.itemName = element["ItemName"] as! String?
                record.price = element["Price"] as! Int32?
                array.append(record)
            })
        })
        return array
    }
    
    //項目取得
    class func find(itemNo: String)->SaleItemModel {
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        
        let request = SQLiteSearchRequest()
        request.contidion = "ItemNo='\(itemNo)'"
        let record = SaleItemModel()
        DataManager.sqlHnadle?.searchData(withReeuest: request, inTable: "SaleItem", searchFinish: { (success, dataArray) in
            dataArray?.forEach({ (element) in
                record.row = element["Row"] as! Int?
                record.itemNo = element["ItemNo"] as! String?
                record.itemName = element["ItemName"] as! String?
                record.price = element["Price"] as! Int32?
            })
        })
        return record
    }
    
    //次の番号取得
    class func getNextNo()->String {
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        
        let sql = "select MAX(ItemNo) MaxNo from SaleItem"
        let fiels:Array<String> = ["MaxNo"]
        var nextno: Int = 0
        DataManager.sqlHnadle?.runSelectSQL(sql, selectField: fiels, searchFinish: { (success, dataArray) in
            dataArray?.forEach({ (element) in
                nextno = Int((element["MaxNo"] as! String?)!)!
            })
        })
        nextno = nextno + 1
        if nextno > 99999 {
            nextno = 1
        }
        return String(format: "%05d", nextno)
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
        
        let price = SQLiteKeyObject()
        price.name = "Price"
        price.fieldType = INTEGER
        
        DataManager.sqlHnadle!.createTable(withName: "SaleItem", keys: [row, itemNo, itemName, price])
        
    }
    
    class func sampleData(){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        let data = SaleItemModel()
        
        data.itemNo = "00001"
        data.itemName = "ラーメン"
        data.price = 800
        self.insert(record: data)

        data.itemNo = "00002"
        data.itemName = "うどん"
        data.price = 500
        self.insert(record: data)

        data.itemNo = "00003"
        data.itemName = "とんかつ定食"
        data.price = 1000
        self.insert(record: data)
    }


}
