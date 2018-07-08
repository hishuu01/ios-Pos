//
//  AccountModel.swift
//  Pos
//
//  Created by YO on 18/03/8.
//  Copyright © 2018年 yo. All rights reserved.
//

import UIKit

class PartnerModel: NSObject {
    var row: Int?
    var partnerNo:String?          //支払先番号
    var partnerName:String?        //支払先名称
    
    func toDictionary() -> Dictionary<String,Any> {
        var dic:[String:Any]
        dic = ["PartnerNo":partnerNo!,"PartnerName":partnerName!]
        if let id = row {
            dic["Row"] = id
        }
        return dic
    }
}
