//
//  AccountModel.swift
//  Pos
//
//  Created by YO on 18/03/8.
//  Copyright © 2018年 yo. All rights reserved.
//

import UIKit

class AccountModel: NSObject {
    var row: Int?
    var accountNo:String?          //科目コード
    var accountName:String?        //科目名称
    
    func toDictionary() -> Dictionary<String,Any> {
        var dic:[String:Any]
        dic = ["AccountNo":accountNo!,"AccountName":accountName!]
        if let id = row {
            dic["Row"] = id
        }
        return dic
    }
}

class AccSumModel: NSObject {
    var accountNo:String?           //科目コード
    var accountName:String?         //科目名称
    var amount: Int32?              //集計金額
    var debit: Int?                 //0:売上  1:仕入
}
