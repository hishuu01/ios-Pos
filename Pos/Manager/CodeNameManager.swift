//
//  DataManager.swift
//  NoteBook
//
//  Created by vip on 16/11/11.
//  Copyright © 2016年 jaki. All rights reserved.
//

import UIKit
import SQLiteSwift3
class CodeNameManager: NSObject {
    class func insert(record:CodeNameModel){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        DataManager.sqlHnadle!.insertData(record.toDictionary(), intoTable: "CodeName")
    }
    
    //コード削除
    class func delete(groupno: String, code:String){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        DataManager.sqlHnadle?.deleteData("GroupNo='\(groupno)' AND Code='\(code)'", intoTable: "CodeName", isSecurity: false)
    }
    
    //指定種別のコード一覧取得
    class func find(groupno:String)->[CodeNameModel]{
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        
        let request = SQLiteSearchRequest()
        request.contidion = "GroupNo='\(groupno)'"
        var array = Array<CodeNameModel>()
        DataManager.sqlHnadle?.searchData(withReeuest: request, inTable: "CodeName", searchFinish: { (success, dataArray) in
            dataArray?.forEach({ (element) in
                let record = CodeNameModel()
                record.row = element["Row"] as! Int?
                record.groupNo = element["GroupNo"] as! String?
                record.groupName = element["GroupName"] as! String?
                record.code = element["Code"] as! String?
                record.cdName = element["CdName"] as! String?
                array.append(record)
            })
        })
        return array
    }
    
    //指定種別のコード一覧取得
    class func getName(groupno:String, code:String)->String {
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        
        let request = SQLiteSearchRequest()
        request.contidion = "GroupNo='\(groupno)' AND Code='\(code)'"
        var array = Array<CodeNameModel>()
        DataManager.sqlHnadle?.searchData(withReeuest: request, inTable: "CodeName", searchFinish: { (success, dataArray) in
            dataArray?.forEach({ (element) in
                let record = CodeNameModel()
                record.row = element["Row"] as! Int?
                record.groupNo = element["GroupNo"] as! String?
                record.groupName = element["GroupName"] as! String?
                record.code = element["Code"] as! String?
                record.cdName = element["CdName"] as! String?
                array.append(record)
            })
        })
        if array.count > 0 {
            return array[0].cdName!
        }
        return ""
    }
    
    class func createTable(){
        
        let row = SQLiteKeyObject()
        row.name = "Row"
        row.fieldType = INTEGER
        row.modificationType = PRIMARY_KEY
        
        let groupNo = SQLiteKeyObject()
        groupNo.name = "GroupNo"
        groupNo.fieldType = TEXT
        
        let groupName = SQLiteKeyObject()
        groupName.name = "GroupName"
        groupName.fieldType = TEXT
        
        let code = SQLiteKeyObject()
        code.name = "Code"
        code.fieldType = TEXT
        
        let cdName = SQLiteKeyObject()
        cdName.name = "CdName"
        cdName.fieldType = TEXT
        
        DataManager.sqlHnadle!.createTable(withName: "CodeName", keys: [row, groupNo, groupName, code, cdName])
        
    }
    
    class func InitData(){
        let data = CodeNameModel()
        
        data.groupNo = "01"
        data.groupName = "支払種別"
        
        data.code = "1"
        data.cdName = "現金"
        self.insert(record: data)
        
        data.code = "2"
        data.cdName = "掛売"
        self.insert(record: data)

    }


}
