//
//  DataManager.swift
//  NoteBook
//
//  Created by vip on 16/11/11.
//  Copyright © 2016年 jaki. All rights reserved.
//

import UIKit
import SQLiteSwift3
class SaleHistoryManager: NSObject {

    //雛形保存
    class func insert(detail:SaleHistoryModel){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        DataManager.sqlHnadle!.insertData(detail.toDictionary(), intoTable: "SaleHistory")        
    }
    
    //雛形を取得
    class func find()->[SaleHistoryModel]{
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        let request = SQLiteSearchRequest()
        request.orderByField = "seq"
        request.orderType = OrderTypeDesc
        var array = Array<SaleHistoryModel>()
        DataManager.sqlHnadle?.searchData(withReeuest: request, inTable: "SaleHistory", searchFinish: { (success, dataArray) in
            dataArray?.forEach({ (element) in
                let detail = SaleHistoryModel()
                detail.row = element["Row"] as! Int?
                detail.itemNo = element["ItemNo"] as! String?
                detail.itemName = element["ItemName"] as! String?
                detail.price = element["Price"] as! Int32?
                detail.qty = element["Qty"] as! Int32?
                detail.total = element["Total"] as! Int32?
                array.append(detail)
            })
        })
        return array
    }
    
    //雛形を取得
    class func find(itemNo: String, price: Int32)-> SaleHistoryModel {
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        let request = SQLiteSearchRequest()
        request.contidion = "ItemNo='\(itemNo)' AND Price=\(price)"
        var array = Array<SaleHistoryModel>()
        DataManager.sqlHnadle?.searchData(withReeuest: request, inTable: "SaleHistory", searchFinish: { (success, dataArray) in
            dataArray?.forEach({ (element) in
                let detail = SaleHistoryModel()
                detail.row = element["Row"] as! Int?
                detail.itemNo = element["ItemNo"] as! String?
                detail.itemName = element["ItemName"] as! String?
                detail.price = element["Price"] as! Int32?
                detail.qty = element["Qty"] as! Int32?
                detail.total = element["Total"] as! Int32?
                array.append(detail)
            })
        })
        var retModel = SaleHistoryModel()
        if array.count > 0 {
            retModel = array[0]
        }
        return retModel
    }

    //雛形削除
    class func delete(seq:Int){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        //首先删除分组下所有记事
        DataManager.sqlHnadle?.deleteData("Seq=\(seq)", intoTable: "SaleHistory", isSecurity: false)
    }
    
    //雛形削除
    class func deleteAll(){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        //首先删除分组下所有记事
        DataManager.sqlHnadle?.deleteData("", intoTable: "SaleHistory", isSecurity: false)
    }

    class func createTable(){
        let row = SQLiteKeyObject()
        row.name = "Seq"
        row.fieldType = INTEGER
        row.modificationType = PRIMARY_KEY
        
        let shnCode = SQLiteKeyObject()
        shnCode.name = "ItemNo"
        shnCode.fieldType = TEXT
        
        let shnName = SQLiteKeyObject()
        shnName.name = "ItemName"
        shnName.fieldType = TEXT
        
        let price = SQLiteKeyObject()
        price.name = "Price"
        price.fieldType = INTEGER
        
        let qty = SQLiteKeyObject()
        qty.name = "Qty"
        qty.fieldType = INTEGER
        
        let total = SQLiteKeyObject()
        total.name = "Total"
        total.fieldType = INTEGER
        
        DataManager.sqlHnadle!.createTable(withName: "SaleHistory", keys: [row,shnCode,shnName,price,qty,total])
        
    }


}
