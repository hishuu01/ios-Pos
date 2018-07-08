//
//  DataManager.swift
//  NoteBook
//
//  Created by vip on 16/11/11.
//  Copyright © 2016年 jaki. All rights reserved.
//

import UIKit
import SQLiteSwift3
class AccountManager: NSObject {
    class func insert(record:AccountModel){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        DataManager.sqlHnadle!.insertData(record.toDictionary(), intoTable: "Account")
    }
    class func update(record:AccountModel){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        DataManager.sqlHnadle!.updateData(record.toDictionary(), intoTable: "Account", while: "Row=\(record.row!)", isSecurity: false)
    }
    //会計科目削除
    class func delete(accountNo:String){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        DataManager.sqlHnadle?.deleteData("AccountNo='\(accountNo)'", intoTable: "Account", isSecurity: false)
    }
    //会計科目全削除
    class func deleteAll(){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        DataManager.sqlHnadle?.deleteData("", intoTable: "Account", isSecurity: false)
    }
    //会計科目取得
    class func find()->[AccountModel]{
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        
        let request = SQLiteSearchRequest()
        var array = Array<AccountModel>()
        DataManager.sqlHnadle?.searchData(withReeuest: request, inTable: "Account", searchFinish: { (success, dataArray) in
            dataArray?.forEach({ (element) in
                let record = AccountModel()
                record.row = element["Row"] as! Int?
                record.accountNo = element["AccountNo"] as! String?
                record.accountName = element["AccountName"] as! String?
                array.append(record)
            })
        })
        return array
    }
    
    //会計科目取得
    class func find(accountNo: String)->[AccountModel]{
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        
        let request = SQLiteSearchRequest()
        request.contidion = "AccountNo='\(accountNo)'"
        var array = Array<AccountModel>()
        DataManager.sqlHnadle?.searchData(withReeuest: request, inTable: "Account", searchFinish: { (success, dataArray) in
            dataArray?.forEach({ (element) in
                let record = AccountModel()
                record.row = element["Row"] as! Int?
                record.accountNo = element["AccountNo"] as! String?
                record.accountName = element["AccountName"] as! String?
                array.append(record)
            })
        })
        return array
    }

    //名称で会計科目取得
    class func findByName(accNo: String, accName: String)->[AccountModel]{
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        
        let request = SQLiteSearchRequest()
        request.contidion = "AccountNo!='\(accNo)' and AccountName='\(accName)'"
        var array = Array<AccountModel>()
        DataManager.sqlHnadle?.searchData(withReeuest: request, inTable: "Account", searchFinish: { (success, dataArray) in
            dataArray?.forEach({ (element) in
                let record = AccountModel()
                record.row = element["Row"] as! Int?
                record.accountNo = element["AccountNo"] as! String?
                record.accountName = element["AccountName"] as! String?
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
        
        let accountNo = SQLiteKeyObject()
        accountNo.name = "AccountNo"
        accountNo.fieldType = TEXT
        
        let accountName = SQLiteKeyObject()
        accountName.name = "AccountName"
        accountName.fieldType = TEXT
        
        DataManager.sqlHnadle!.createTable(withName: "Account", keys: [row,accountNo,accountName])
        
    }
    
    class func sampleData(){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        let data = AccountModel()
        
        data.accountNo = "1101"
        data.accountName = "水道光熱費"
        self.insert(record: data)
        
        data.accountNo = "1102"
        data.accountName = "旅費交通費"
        self.insert(record: data)
        
        data.accountNo = "1103"
        data.accountName = "地代家賃"
        self.insert(record: data)
    }
    
}
