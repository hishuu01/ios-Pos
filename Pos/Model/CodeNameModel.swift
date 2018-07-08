//
//  AccountModel.swift
//  Pos
//
//  Created by YO on 18/03/8.
//  Copyright © 2018年 yo. All rights reserved.
//

import UIKit

class CodeNameModel: NSObject {
    var row: Int?           //rowid
    var groupNo: String?    //グループ
    var groupName: String?  //グループ名
    var code:String?        //コード
    var cdName:String?      //名称
    
    func toDictionary() -> Dictionary<String,Any> {
        var dic:[String:Any]
        dic = ["GroupNo":groupNo!,"Code":code!,"CdName":cdName!]
        if let id = row {
            dic["Row"] = id
        }
        if let grpnm = groupName {
            dic["groupName"] = grpnm
        }
        return dic
    }
}
