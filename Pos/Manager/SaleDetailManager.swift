//
//  DataManager.swift
//  NoteBook
//
//  Created by vip on 16/11/11.
//  Copyright © 2016年 jaki. All rights reserved.
//

import UIKit
import SQLiteSwift3
class SaleDetailManager: NSObject {
    
     class func insert(detail:SaleDetailModel){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        DataManager.sqlHnadle!.insertData(detail.toDictionary(), intoTable: "SaleDetail")
    }

    //売上明細削除
    class func delete(slipNo:String, saleDate:String){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        DataManager.sqlHnadle?.deleteData("SlipNo='\(slipNo)' AND SaleDate='\(saleDate)'", intoTable: "SaleDetail", isSecurity: false)
    }
    
    //売上明細取得
    class func find(slipNo:String, saleDate:String)->[SaleDetailModel]{
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        
        let request = SQLiteSearchRequest()
        request.contidion = "SlipNo='\(slipNo)' AND SaleDate='\(saleDate)'"
        var array = Array<SaleDetailModel>()
        DataManager.sqlHnadle?.searchData(withReeuest: request, inTable: "SaleDetail", searchFinish: { (success, dataArray) in
            dataArray?.forEach({ (element) in
                let detail = SaleDetailModel()
                detail.row = element["Row"] as! Int?
                detail.slipNo = element["SlipNo"] as! String?
                detail.saleDate = element["SaleDate"] as! String?
                detail.seq = element["Seq"] as! Int?
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
    
    class func createTable(){
        let row = SQLiteKeyObject()
        row.name = "Row"
        row.fieldType = INTEGER
        row.modificationType = PRIMARY_KEY
        
        let slipNo = SQLiteKeyObject()
        slipNo.name = "SlipNo"
        slipNo.fieldType = TEXT
        
        let saleDate = SQLiteKeyObject()
        saleDate.name = "SaleDate"
        saleDate.fieldType = TEXT
        
        let seq = SQLiteKeyObject()
        seq.name = "Seq"
        seq.fieldType = INTEGER

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
        
        DataManager.sqlHnadle!.createTable(withName: "SaleDetail", keys: [row, slipNo,saleDate,seq,shnCode,shnName,price,qty,total])

    }
    

}
