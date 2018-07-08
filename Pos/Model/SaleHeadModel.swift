//
//  NoteModel.swift
//  NoteBook
//
//  Created by vip on 16/11/12.
//  Copyright © 2016年 jaki. All rights reserved.
//

import UIKit

class SaleHeadModel: NSObject {
    var row: Int?               //rowid
    var slipNo:String?          //レシート番号
    var saleDate:String?        //売上日
    var qty:Int32?              //総点数
    var total:Int32?            //総金額
    var payNo:String?           //支払種別番号
    var payName:String?         //支払種別
    var payAmount:Int32?        //支払金額
    var change:Int32?           //釣り銭
    var empNo:String?           //従業員番号
    var time:String?            //登録時刻
    
    func toDictionary() -> Dictionary<String,Any> {
        var dic:[String:Any] = ["SlipNo":slipNo!,"SaleDate":saleDate!,"Qty":qty!,"Total":total!,"PayNo":payNo!, "PayName":payName!, "PayAmount":payAmount!,"Change":change!,"Time":time!]
        if let id = row {
            dic["Row"] = id
        }
        if let tmp = empNo {
            dic["EmpNo"] = tmp
        }
        return dic
    }
}
