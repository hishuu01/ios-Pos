//
//  DataManager.swift
//  NoteBook
//
//  Created by vip on 16/11/11.
//  Copyright © 2016年 jaki. All rights reserved.
//

import UIKit
import SQLiteSwift3
class PayManager: NSObject {

    //売上保存
    class func insert(record:PayModel){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        DataManager.sqlHnadle!.insertData(record.toDictionary(), intoTable: "Pay")
    }
    
    //削除
    class func delete(rowId:Int){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        DataManager.sqlHnadle?.deleteData("Row=\(rowId)", intoTable: "Pay", isSecurity: false)
    }

    //取得
    class func find(rowId:Int)->[PayModel]{
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        
        let request = SQLiteSearchRequest()
        request.contidion = "Row=\(rowId)"
        var array = Array<PayModel>()
        DataManager.sqlHnadle?.searchData(withReeuest: request, inTable: "Pay", searchFinish: { (success, dataArray) in
            dataArray?.forEach({ (element) in
                let detail = PayModel()
                detail.row = element["Row"] as! Int?
                detail.payDate = element["PayDate"] as! String?
                detail.partnerNo = element["PartnerNo"] as! String?
                detail.costItemNo = element["CostItemNo"] as! String?
                detail.amount = element["Amount"] as! Int32?
                detail.empNo = element["EmpNo"] as! String?
                detail.time = element["Time"] as! String?
                array.append(detail)
            })
        })
        return array
    }

    //出金取得
    class func getDayPay(payDate:String)->[PayViewModel]{
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        
        let sql = "select p.Row, p.PartnerNo, m1.PartnerName, p.CostItemNo, m2.ItemName as CostItemName, p.Amount from Pay as p left join Partner m1 on p.PartnerNo = m1.PartnerNo left join CostItem as m2 on p.CostItemNo = m2.ItemNo where p.PayDate='\(payDate)'"
        let fiels:Array<String> = ["Row", "PartnerNo", "PartnerName", "CostItemNo", "CostItemName", "Amount"]
        var array = Array<PayViewModel>()
        DataManager.sqlHnadle?.runSelectSQL(sql, selectField: fiels, searchFinish: { (success, dataArray) in
            dataArray?.forEach({ (element) in
                let detail = PayViewModel()
                detail.row = Int((element["Row"] as! String?)!)
                detail.partnerNo = element["PartnerNo"] as! String?
                detail.partnerName = element["PartnerName"] as! String?
                detail.costItemNo = element["CostItemNo"] as! String?
                detail.costItemName = element["CostItemName"] as! String?
                detail.amount = Int32((element["Amount"] as! String?)!)
                array.append(detail)
            })
        })
        return array
    }
    
    //科目別出金集計
    class func getSumByAccount(payDate:String)->[AccSumModel]{
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        
        let sql = "select a.AccountName, SUM(p.Amount) as Amount from Pay as p join CostItem as c on p.CostItemNo = c.ItemNo left join Account as a on c.AccountNo = a.AccountNo where p.PayDate='\(payDate)' group by a.AccountName"
        let fiels:Array<String> = ["AccountName", "Amount"]
        var array = Array<AccSumModel>()
        DataManager.sqlHnadle?.runSelectSQL(sql, selectField: fiels, searchFinish: { (success, dataArray) in
            dataArray?.forEach({ (element) in
                let detail = AccSumModel()
                //detail.accountNo = element["AccountNo"] as! String?
                let tmp = element["AccountName"] as! String?
                if tmp == "NULL" {
                    detail.accountName = "未定義"
                }
                else {
                    detail.accountName = tmp
                }
                detail.amount = Int32((element["Amount"] as! String?)!)
                array.append(detail)
            })
        })
        return array
    }
    
    
    //出金金額取得
    class func getDaySum(payDate: String)->Int32 {
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        
        let sql = "select SUM(Amount) as Total from Pay where PayDate='\(payDate)'"
        let fiels:Array<String> = ["Total"]
        var total: Int32 = 0
        DataManager.sqlHnadle?.runSelectSQL(sql, selectField: fiels, searchFinish: { (success, dataArray) in
            dataArray?.forEach({ (element) in
                let tmp = element["Total"] as? String
                if tmp != "NULL" {
                    total = total + Int32(tmp!)!
                }
            })
        })
        return total
    }
    
    //科目別金額取得
    class func getAccSum()->[AccSumModel] {
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        
        let thisYear = Common.today().substr(start:1, length:4)
        let sql = "select a.AccountNo, a.AccountName, sum(p.Amount) as Amount from Account as a left join CostItem as c on a.AccountNo = c.AccountNo left join  (select * from Pay where PayDate like '\(thisYear)%') as p on c.ItemNo = p.CostItemNo group by a.AccountNo, a.AccountName"
        let fiels:Array<String> = ["AccountNo", "AccountName", "Amount"]
        var array = Array<AccSumModel>()
        DataManager.sqlHnadle?.runSelectSQL(sql, selectField: fiels, searchFinish: { (success, dataArray) in
            dataArray?.forEach({ (element) in
                let detail = AccSumModel()
                detail.accountNo = element["AccountNo"] as! String?
                detail.accountName = element["AccountName"] as! String?
                detail.debit = 1
                let tmp = element["Amount"] as! String
                if tmp == "NULL" {
                    detail.amount = 0
                }
                else {
                    detail.amount = Int32(tmp)
                }
                array.append(detail)
            })
        })
        return array
    }

    //月別金額取得
    class func getAccSumByMon(accNo: String)->[AccSumModel] {
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        
        let thisYear = Common.today().substr(start:1, length:4)
        let sql = "select substr(p.PayDate,1,6) as Mon, SUM(Amount) as Amount from Pay as p join CostItem as c on p.CostItemNo = c.ItemNo where PayDate like '\(thisYear)%' and c.AccountNo='\(accNo)' group by substr(p.PayDate,1,6)"
        let fiels:Array<String> = ["Mon", "Amount"]
        var array = Array<AccSumModel>()
        DataManager.sqlHnadle?.runSelectSQL(sql, selectField: fiels, searchFinish: { (success, dataArray) in
            dataArray?.forEach({ (element) in
                let detail = AccSumModel()
                detail.accountName = element["Mon"] as! String?
                detail.amount = Int32(element["Amount"] as! String)
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
        
        let payDate = SQLiteKeyObject()
        payDate.name = "PayDate"
        payDate.fieldType = TEXT
        
        let partnerNo = SQLiteKeyObject()
        partnerNo.name = "PartnerNo"
        partnerNo.fieldType = TEXT

        let costItemNo = SQLiteKeyObject()
        costItemNo.name = "CostItemNo"
        costItemNo.fieldType = TEXT

        let amount = SQLiteKeyObject()
        amount.name = "Amount"
        amount.fieldType = INTEGER

        let empNo = SQLiteKeyObject()
        empNo.name = "EmpNo"
        empNo.fieldType = TEXT
        
        let time = SQLiteKeyObject()
        time.name = "Time"
        time.fieldType = TEXT
        
        DataManager.sqlHnadle!.createTable(withName: "Pay", keys: [row,payDate,partnerNo,costItemNo,amount,empNo,time])
    }
    
}
