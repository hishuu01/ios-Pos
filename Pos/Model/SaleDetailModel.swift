//
//  NoteModel.swift
//  NoteBook
//
//  Created by vip on 16/11/12.
//  Copyright © 2016年 jaki. All rights reserved.
//

import UIKit

class SaleDetailModel: NSObject {
    var row: Int?               //rowid
    var slipNo:String?          //レシート番号
    var saleDate:String?        //売上日
    var seq:Int?                //シーク番号
    var itemNo:String?          //項目コード
    var itemName:String?        //項目名称
    var price:Int32?            //単価
    var qty:Int32?              //点数
    var total:Int32?            //金額
    
    func toDictionary() -> Dictionary<String,Any> {
        var dic:[String:Any] = ["SlipNo":slipNo!,"SaleDate":saleDate!,"Seq":seq!,"ItemNo":itemNo!,"ItemName":itemName!,"Qty":qty!,"Total":total!]
        if let id = row {
            dic["Row"] = id
        }
        if let tmp = price {
            dic["Price"] = tmp
        }
        return dic
    }

}
