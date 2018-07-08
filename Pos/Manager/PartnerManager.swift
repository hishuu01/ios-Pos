//
//  DataManager.swift
//  NoteBook
//
//  Created by vip on 16/11/11.
//  Copyright © 2016年 jaki. All rights reserved.
//

import UIKit
import SQLiteSwift3
class PartnerManager: NSObject {
    class func insert(record:PartnerModel){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        DataManager.sqlHnadle!.insertData(record.toDictionary(), intoTable: "Partner")
    }
    
    class func update(record:PartnerModel){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        DataManager.sqlHnadle!.updateData(record.toDictionary(), intoTable: "Partner", while: "Row=\(record.row!)", isSecurity: false)
    }
    //支払先削除
    class func delete(partnerNo:String){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        DataManager.sqlHnadle?.deleteData("PartnerNo='\(partnerNo)'", intoTable: "Partner", isSecurity: false)
    }
    //全削除
    class func deleteAll(){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        DataManager.sqlHnadle?.deleteData("", intoTable: "Partner", isSecurity: false)
    }
    //支払先取得
    class func find()->[PartnerModel]{
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        
        let request = SQLiteSearchRequest()
        var array = Array<PartnerModel>()
        DataManager.sqlHnadle?.searchData(withReeuest: request, inTable: "Partner", searchFinish: { (success, dataArray) in
            dataArray?.forEach({ (element) in
                let record = PartnerModel()
                record.row = element["Row"] as! Int?
                record.partnerNo = element["PartnerNo"] as! String?
                record.partnerName = element["PartnerName"] as! String?
                array.append(record)
            })
        })
        return array
    }
    //次の番号取得
    class func getNextNo()->String {
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        
        let sql = "select MAX(ItemNo) MaxNo from SaleItem"
        let fiels:Array<String> = ["MaxNo"]
        var nextno: Int?
        DataManager.sqlHnadle?.runSelectSQL(sql, selectField: fiels, searchFinish: { (success, dataArray) in
            dataArray?.forEach({ (element) in
                nextno = Int((element["MaxNo"] as! String?)!)
            })
        })
        nextno = nextno! + 1
        if nextno! > 99999 {
            nextno = 1
        }
        return String(format: "%05d", nextno!)
    }
    class func createTable(){
        let row = SQLiteKeyObject()
        row.name = "Row"
        row.fieldType = INTEGER
        row.modificationType = PRIMARY_KEY
        
        let partnerNo = SQLiteKeyObject()
        partnerNo.name = "PartnerNo"
        partnerNo.fieldType = TEXT
        
        let partnerName = SQLiteKeyObject()
        partnerName.name = "PartnerName"
        partnerName.fieldType = TEXT
        
        DataManager.sqlHnadle!.createTable(withName: "Partner", keys: [row, partnerNo,partnerName])
        
    }
    
    class func sampleData(){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        let data = PartnerModel()
        
        data.partnerNo = "0001"
        data.partnerName = "東京電力"
        self.insert(record: data)
        
        data.partnerNo = "0002"
        data.partnerName = "JR東日本"
        self.insert(record: data)
        
        data.partnerNo = "0003"
        data.partnerName = "セントラリ"
        self.insert(record: data)
    }
}
