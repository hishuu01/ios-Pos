//
//  DataManager.swift
//  NoteBook
//
//  Created by vip on 16/11/11.
//  Copyright © 2016年 jaki. All rights reserved.
//

import UIKit
import SQLiteSwift3
class DataManager: NSObject {
    static var sqlHnadle:SQLiteSwift3?
    static var isOpen = false
    //データベースオープン
    class func openDataBase(){
        let file = getDBFile()
        sqlHnadle = SQLiteSwift3.openDB(file)
        isOpen=true
    }
    
    class private func isExistDb()->Bool {
        let fileManager = FileManager.default
        let file = getDBFile()
        let exist = fileManager.fileExists(atPath: file)
        return exist
    }
    
    class private func getDBFile()->String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let file = path + "/DataBase.sqlite"
        return file
    }
    
    class func initDB(){
        if isExistDb() {
            return
        }
        if !self.isOpen {
            self.openDataBase()
        }
        SaleHeadManager.createTable()
        SaleDetailManager.createTable()
        SaleItemManager.createTable()
        SaleHistoryManager.createTable()
        PayManager.createTable()
        CostItemManager.createTable()
        PartnerManager.createTable()
        AccountManager.createTable()
        CodeNameManager.createTable()
        
        //init Data
        SaleItemManager.sampleData()
        AccountManager.sampleData()
        CostItemManager.sampleData()
        PartnerManager.sampleData()
        CodeNameManager.InitData()
    }

}
