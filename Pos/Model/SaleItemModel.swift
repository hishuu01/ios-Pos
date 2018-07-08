//
//  ItemModel.swift
//  Pos
//
//  Created by YO on 18/03/8.
//  Copyright © 2018年 yo. All rights reserved.
//

import UIKit

class SaleItemModel: NSObject {
    var row: Int?
    var itemNo:String?          //項目番号
    var itemName:String?        //項目名称
    var price:Int32?            //単価
    
    func toDictionary() -> Dictionary<String,Any> {
        var dic:[String:Any]
        dic = ["ItemNo":itemNo!,"ItemName":itemName!]
        if let tmp = price {
            dic["Price"] = tmp
        }
        if let id = row {
            dic["Row"] = id
        }
        return dic
    }
}
