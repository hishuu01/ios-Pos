//
//  NoteModel.swift
//  NoteBook
//
//  Created by vip on 16/11/12.
//  Copyright © 2016年 jaki. All rights reserved.
//

import UIKit

class PayModel: NSObject {
    var row: Int?               //rowid
    var payDate:String?         //出金日
    var partnerNo:String?       //出金先
    var costItemNo:String?      //出金項目
    var amount:Int32?           //出金金額
    var empNo:String?           //従業員番号
    var time:String?            //登録時刻
    
    func toDictionary() -> Dictionary<String,Any> {
        var dic:[String:Any] = ["PayDate":payDate!,"PartnerNo":partnerNo!,"CostItemNo":costItemNo!, "Amount":amount!,"Time":time!]
        if let id = row {
            dic["Row"] = id
        }
        if let tmp = empNo {
            dic["EmpNo"] = tmp
        }
        return dic
    }
}

class PayViewModel: NSObject {
    var row: Int?               //rowid
    var partnerNo:String?       //出金先
    var partnerName:String?     //出金先名
    var costItemNo:String?      //出金項目
    var costItemName:String?    //項目名
    var amount:Int32?           //出金金額
}
