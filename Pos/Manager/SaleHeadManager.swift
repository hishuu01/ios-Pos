//
//  DataManager.swift
//  NoteBook
//
//  Created by vip on 16/11/11.
//  Copyright © 2016年 jaki. All rights reserved.
//

import UIKit
import SQLiteSwift3
class SaleHeadManager: NSObject {

    //売上保存
    class func insert(head:SaleHeadModel){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        DataManager.sqlHnadle!.insertData(head.toDictionary(), intoTable: "SaleHead")
    }
    
    //売上削除
    class func delete(slipNo:String, saleDate:String){
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        DataManager.sqlHnadle?.deleteData("SlipNo='\(slipNo)' AND SaleDate='\(saleDate)'", intoTable: "SaleHead", isSecurity: false)
    }

    //売上取得
    class func find(slipNo:String, saleDate:String)->[SaleHeadModel]{
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        
        let request = SQLiteSearchRequest()
        request.contidion = "SlipNo='\(slipNo)' AND SaleDate='\(saleDate)'"
        var array = Array<SaleHeadModel>()
        DataManager.sqlHnadle?.searchData(withReeuest: request, inTable: "SaleHead", searchFinish: { (success, dataArray) in
            dataArray?.forEach({ (element) in
                let detail = SaleHeadModel()
                detail.row = element["Row"] as! Int?
                detail.slipNo = element["SlipNo"] as! String?
                detail.saleDate = element["SaleDate"] as! String?
                detail.qty = element["Qty"] as! Int32?
                detail.total = element["Total"] as! Int32?
                detail.payNo = element["PayNo"] as! String?
                detail.payName = element["PayName"] as! String?
                detail.payAmount = element["PayAmount"] as! Int32?
                detail.change = element["Change"] as! Int32?
                detail.empNo = element["EmpNo"] as! String?
                detail.time = element["Time"] as! String?
                array.append(detail)
            })
        })
        return array
    }

    //売上取得
    class func getMonSum()->[SummaryModel]{
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        let thisYear = Common.today().substr(start:1, length:4)
        let sql = "select a.Mon, sum(a.SaleAmount) as SaleAmount, sum(a.SaleQty) as SaleQty, sum(a.PayAmount) as PayAmount from (select substr(SaleDate,1,6) as Mon, Total as SaleAmount, Qty as SaleQty, 0 as PayAmount from SaleHead where substr(SaleDate,1,4) == '\(thisYear)' union all select substr(PayDate,1,6) as Mon, 0 as SaleAmount, 0 as SaleQty, Amount as PayAmount from Pay where substr(PayDate,1,4) == '\(thisYear)') as a group by a.Mon"
        let fiels:Array<String> = ["Mon", "SaleAmount", "SaleQty", "PayAmount"]
        var array = Array<SummaryModel>()
        DataManager.sqlHnadle?.runSelectSQL(sql, selectField: fiels, searchFinish: { (success, dataArray) in
            dataArray?.forEach({ (element) in
                let detail = SummaryModel()
                detail.dateStr = element["Mon"] as! String?
                detail.saleAmount = Int32(element["SaleAmount"] as! String)
                detail.saleQty = Int32(element["SaleQty"] as! String)
                detail.payAmount = Int32(element["PayAmount"] as! String)
                array.append(detail)
            })
        })
        return array
    }
    //売上取得
    class func getDaySum(Mon: String)->[SummaryModel]{
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        
        let sql = "select a.SumDay, sum(a.SaleAmount) as SaleAmount, sum(a.SaleQty) as SaleQty, sum(a.PayAmount) as PayAmount from (select SaleDate as SumDay, Total as SaleAmount, Qty as SaleQty, 0 as PayAmount from SaleHead where SaleDate like '\(Mon)%' union all select PayDate as SumDay, 0 as SaleAmount, 0 as SaleQty, Amount as PayAmount from Pay where PayDate like '\(Mon)%') as a group by a.SumDay"
        let fiels:Array<String> = ["SumDay", "SaleAmount", "SaleQty", "PayAmount"]
        var array = Array<SummaryModel>()
        DataManager.sqlHnadle?.runSelectSQL(sql, selectField: fiels, searchFinish: { (success, dataArray) in
            dataArray?.forEach({ (element) in
                let detail = SummaryModel()
                detail.dateStr = element["SumDay"] as! String?
                detail.saleAmount = Int32(element["SaleAmount"] as! String)
                detail.saleQty = Int32(element["SaleQty"] as! String)
                detail.payAmount = Int32(element["PayAmount"] as! String)
                array.append(detail)
            })
        })
        return array
    }

    //売上取得
    class func getDaySale(saleDate:String)->[SaleHeadModel]{
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        
        let request = SQLiteSearchRequest()
        request.contidion = "SaleDate='\(saleDate)'"
        var array = Array<SaleHeadModel>()
        DataManager.sqlHnadle?.searchData(withReeuest: request, inTable: "SaleHead", searchFinish: { (success, dataArray) in
            dataArray?.forEach({ (element) in
                let detail = SaleHeadModel()
                detail.row = element["Row"] as! Int?
                detail.slipNo = element["SlipNo"] as! String?
                detail.saleDate = element["SaleDate"] as! String?
                detail.qty = element["Qty"] as! Int32?
                detail.total = element["Total"] as! Int32?
                detail.payNo = element["PayNo"] as! String?
                detail.payName = element["PayName"] as! String?
                detail.payAmount = element["PayAmount"] as! Int32?
                detail.change = element["Change"] as! Int32?
                detail.empNo = element["EmpNo"] as! String?
                detail.time = element["Time"] as! String?
                array.append(detail)
            })
        })
        return array
    }
    //決済別年間集計
    class func getAccSum()->[AccSumModel]{
        var sale: AccSumModel
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        
        let thisYear = Common.today().substr(start:1, length:4)
        let sql = "select PayNo as AccountNo, Sum(Total) as Amount from SaleHead where SaleDate like '\(thisYear)%' group by PayNo"
        let fiels:Array<String> = ["AccountNo", "Amount"]
        var array = Array<AccSumModel>()
        
        sale = AccSumModel()
        sale.accountNo = "1"
        sale.accountName = "現金売上"
        sale.debit = 0
        sale.amount = 0
        array.append(sale)
        
        sale = AccSumModel()
        sale.accountNo = "2"
        sale.accountName = "掛売上"
        sale.debit = 0
        sale.amount = 0
        array.append(sale)
        
        DataManager.sqlHnadle?.runSelectSQL(sql, selectField: fiels, searchFinish: { (success, dataArray) in
            dataArray?.forEach({ (element) in
                var detail = AccSumModel()
                if element["AccountNo"] as! String? == "1" {
                    detail = array[0]
                }
                else if element["AccountNo"] as! String? == "2" {
                    detail = array[1]
                }
                detail.amount = Int32(element["Amount"] as! String)
            })
        })
        return array
    }
    
    //月別決済集計
    class func getAccSumByMon(payNo: String) -> [AccSumModel] {
        if !DataManager.isOpen {
            DataManager.openDataBase()
        }
        
        let thisYear = Common.today().substr(start:1, length:4)
        let sql = "select substr(SaleDate,1,6) as Mon, Sum(Total) as Amount from SaleHead where SaleDate like '\(thisYear)%' and PayNo='\(payNo)' group by substr(SaleDate,1,6)"
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
    
    //レシート番号発番
    class func getSlipNo() -> String {
        //伝票番号
        let userDefaults = UserDefaults.standard
        var no = userDefaults.integer(forKey: "SlipNo")
        no = no + 1
        userDefaults.set(no, forKey: "SlipNo")
        return String(format: "%07d", no)
    }


    class func createTable(){
        //伝票番号
        let userDefaults = UserDefaults.standard
        userDefaults.set(0, forKey: "SlipNo")
        
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
        
        let qty = SQLiteKeyObject()
        qty.name = "Qty"
        qty.fieldType = INTEGER
        
        let total = SQLiteKeyObject()
        total.name = "Total"
        total.fieldType = INTEGER
        
        let payNo = SQLiteKeyObject()
        payNo.name = "PayNo"
        payNo.fieldType = TEXT

        let payName = SQLiteKeyObject()
        payName.name = "PayName"
        payName.fieldType = TEXT

        let payAmount = SQLiteKeyObject()
        payAmount.name = "PayAmount"
        payAmount.fieldType = INTEGER

        let change = SQLiteKeyObject()
        change.name = "Change"
        change.fieldType = INTEGER

        let empNo = SQLiteKeyObject()
        empNo.name = "EmpNo"
        empNo.fieldType = TEXT
        
        let time = SQLiteKeyObject()
        time.name = "Time"
        time.fieldType = TEXT
        
        DataManager.sqlHnadle!.createTable(withName: "SaleHead", keys: [row,slipNo,saleDate,qty,total,payNo,payName,payAmount,change,empNo,time])
    }
    
}
