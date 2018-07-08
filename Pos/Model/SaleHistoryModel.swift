//
//  NoteModel.swift
//  NoteBook
//
//  Created by vip on 16/11/12.
//  Copyright © 2016年 jaki. All rights reserved.
//

import UIKit

class SaleHistoryModel: NSObject {
    var row:Int?                //rowid
    var itemNo:String?          //項目コード
    var itemName:String?        //項目名称
    var price:Int32?            //単価
    var qty:Int32?              //点数
    var total:Int32?            //金額
    
    func toDictionary() -> Dictionary<String,Any> {
        var dic:[String:Any] = ["ItemNo":itemNo!,"ItemName":itemName!,"Qty":qty!,"Total":total!]

        if let pricetmp = price {
            dic["Price"] = pricetmp
        }
        
        if let id = row {
            dic["Row"] = id
        }
        return dic
    }
}
