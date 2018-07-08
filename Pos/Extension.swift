//
//  Common.swift
//  Pos
//
//  Created by hishuu on 2018/3/21.
//  Copyright © 2018年 yo. All rights reserved.
//

import UIKit

extension UIAlertController {
    //alert
    class func showAlert(message: String, in viewController: UIViewController) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        viewController.present(alert, animated: true)
    }
}

extension String {
    /**
    get substring from string
    
    @param start start position
    @param length substring length
     
    @return substring
    */
    func substr(start: Int, length: Int) -> String {
        // start index
        var str: String
        let startidx: String.Index = self.index(self.startIndex, offsetBy:(start-1))
        // end index
        if start + length > self.characters.count {
            str = self.substring(from:startidx)
        }
        else {
            let endidx = self.index(self.startIndex, offsetBy:(start+length-1))
            str = self.substring(with:startidx..<endidx)
        }
        return str
    }
}
