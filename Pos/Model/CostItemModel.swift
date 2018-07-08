//
//  AccountModel.swift
//  Pos
//
//  Created by YO on 18/03/8.
//  Copyright © 2018年 yo. All rights reserved.
//

import UIKit

class CostItemModel: NSObject {
    var row: Int?
    var itemNo:String?          //項目番号
    var itemName:String?        //項目名称
    var accountNo:String?       //所属科目コード
    
    func toDictionary() -> Dictionary<String,Any> {
        var dic:[String:Any]
        dic = ["ItemNo":itemNo!,"ItemName":itemName!,"AccountNo":accountNo!]
        if let id = row {
            dic["Row"] = id
        }
        return dic
    }
}

class CostItemViewModel: NSObject {
    var row: Int?
    var itemNo:String?          //項目番号
    var itemName:String?        //項目名称
    var accountNo:String?       //所属科目コード
    var accountName:String?     //科目名

}
