//
//  SaleViewController.swift
//  POS
//
//  Created by Yo on 18/3/6.
//  Copyright © 2018年 yo. All rights reserved.
//

import UIKit
import SnapKit
class SaleQRViewController: UIViewController {

    var saleHead = SaleHeadModel()
    var saleDetails = Array<SaleDetailModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "伝票情報QR"
        self.view.backgroundColor = UIColor.white
        installUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func installUI() {
        var salecode: String = ""
  
        /*salecode = saleHead.slipNo! + "," + saleHead.saleDate! + "," + String(format:"%d",saleHead.qty!) + "," + String(format:"%d",saleHead.totale!) + "," + saleHead.payNo! + "," + saleHead.payName! + "," + String(format:"%d",saleHead.payAmount!) + "," + String(format:"%d",saleHead.change!) + "," + saleHead.empNo! + ","  + saleHead.time!*/
        let headdic = saleHead.toDictionary()
        do {
            // DictionaryをJSONデータに変換
            let jsonData = try JSONSerialization.data(withJSONObject: headdic)
            // JSONデータを文字列に変換
            salecode = String(bytes: jsonData, encoding: .utf8)!
        }
        catch {
        }
        
        for detail : SaleDetailModel in saleDetails{
            let detaildic = detail.toDictionary()
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: detaildic)
                salecode = salecode + "¥n" + String(bytes: jsonData, encoding: .utf8)!
            }
            catch {
            }
        }
        
        let windowSize = self.view.frame.size
        let codeSize = CGSize(width:windowSize.width*3/4, height:windowSize.width*3/4)
        let codeImage = createQRImageWithString(salecode, andSize: codeSize)
        
        let imgView = UIImageView(image: codeImage);
        imgView.frame = CGRect(x:(windowSize.width-codeSize.width)/2,
                               y:(windowSize.height-codeSize.height)/2,
                               width:codeSize.width,
                               height:codeSize.height);
        self.view.addSubview(imgView)
    }
    
    //QRコードを作成する
    func createQRImageWithString(_ stirng:String, andSize size:CGSize) -> UIImage {
        
        let stringData:Data = stirng.data(using:String.Encoding(rawValue:String.Encoding.utf8.rawValue))!
        
        let qrFileter = CIFilter(name: "CIQRCodeGenerator")
        qrFileter?.setValue(stringData, forKey:"inputMessage")
        qrFileter?.setValue("M", forKey:"inputCorrectionLevel")
        let qrImage = qrFileter?.outputImage

        let cgImage = CIContext(options: nil).createCGImage(qrImage!, from: (qrImage?.extent)!)
        
        UIGraphicsBeginImageContext(size)
        
        let context = UIGraphicsGetCurrentContext()
        context!.interpolationQuality = .none
        //反转一下图片，不然生产的QRCode就是上下颠倒的
        context!.scaleBy(x:1.0, y: -1.0);
        context?.draw(cgImage!, in: context!.boundingBoxOfClipPath)
        let codeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        let qrimage = addSmallImageForQRImage(qrImage: codeImage)
    
        return qrimage
    }
    
    // マークをQRコードの中心的に追加する
    func  addSmallImageForQRImage(qrImage:UIImage) -> UIImage {
        
        UIGraphicsBeginImageContext(qrImage.size)
        
        qrImage.draw(in:CGRect(x: 0, y:0, width: qrImage.size.width, height: qrImage.size.height))
        let iamge = UIImage(named: "AppIcon")
        let iamgeW:CGFloat = 50
        let iamgeX = (qrImage.size.width - iamgeW)*0.5
        let iamgeY = (qrImage.size.height - iamgeW)*0.5
        iamge?.draw(in:CGRect(x: iamgeX, y: iamgeY, width: iamgeW, height: iamgeW))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return result!
        
    }
}

