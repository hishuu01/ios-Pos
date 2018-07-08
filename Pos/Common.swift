//
//  Common.swift
//  Pos
//
//  Created by hishuu on 2018/3/22.
//  Copyright © 2018年 jaki. All rights reserved.
//

import UIKit

class Common: NSObject {
    
    //数字を文字列に変換、カンマ編集
    class func formatNumberStr(num: Int32) -> String{
        let g_nsNumberFormatter = NumberFormatter()
        g_nsNumberFormatter.numberStyle = NumberFormatter.Style.decimal
        g_nsNumberFormatter.groupingSeparator = "," // 区切り文字
        g_nsNumberFormatter.groupingSize = 3        // 区切り位置
        return g_nsNumberFormatter.string(from: NSNumber(value:num))!
    }
    
    class func today() -> String {
        let now = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyyMMdd"
        return dateformatter.string(from: now)
    }
}
