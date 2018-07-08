//
//  SaleView.swift
//  NoteBook
//
//  Created by yo on 18/3/5.
//  Copyright © 2018年 yo. All rights reserved.
//
import UIKit
import AVFoundation

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var saleHead = SaleHeadModel()
    var saleDetails = Array<SaleDetailModel>()
    var setDetail:((SaleDetailModel)->Void)?
    
    var scanRectView:UIView?
    var device:AVCaptureDevice?
    var input:AVCaptureInput?
    var output:AVCaptureMetadataOutput?
    var session:AVCaptureSession?
    var preview:AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "スキャン"
        fromCamera()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //dataArray = DataManager.getGroupData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.session!.stopRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //scan with camera
    func fromCamera() {
        do{
            self.device = AVCaptureDevice.default(for: AVMediaType.video)
            self.input = try AVCaptureDeviceInput(device: self.device!)
            
            self.output = AVCaptureMetadataOutput()


            self.session = AVCaptureSession()
            if UIScreen.main.bounds.size.height<500 {
                self.session?.sessionPreset = AVCaptureSession.Preset.vga640x480
            }else{
                self.session?.sessionPreset = AVCaptureSession.Preset.high
            }
            
            self.session?.addInput(self.input!)
            self.session?.addOutput(self.output!)
            
            self.output?.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            self.output?.metadataObjectTypes = [AVMetadataObject.ObjectType.qr, AVMetadataObject.ObjectType.code128,AVMetadataObject.ObjectType.code39,AVMetadataObject.ObjectType.ean13,AVMetadataObject.ObjectType.ean8,AVMetadataObject.ObjectType.code39Mod43]
            
            //计算中间可探测区域
            let windowSize = UIScreen.main.bounds.size
            let scanSize = CGSize(width:windowSize.width*3/4, height:windowSize.width*3/4)
            var scanRect = CGRect(x:(windowSize.width-scanSize.width)/2,
                                  y:(windowSize.height-scanSize.height)/2,
                                  width:scanSize.width, height:scanSize.height)
            createBackGroundView(scanFram: scanRect)
            //计算rectOfInterest 注意x,y交换位置
            scanRect = CGRect(x:scanRect.origin.y/windowSize.height,
                              y:scanRect.origin.x/windowSize.width,
                              width:scanRect.size.height/windowSize.height,
                              height:scanRect.size.width/windowSize.width);
            //设置可探测区域
            self.output?.rectOfInterest = scanRect
            
            self.preview = AVCaptureVideoPreviewLayer(session:self.session!)
            self.preview?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.preview?.frame = UIScreen.main.bounds
            self.view.layer.insertSublayer(self.preview!, at:0)
            
            //添加中间的探测区域绿框
            self.scanRectView = UIView();
            self.view.addSubview(self.scanRectView!)
            self.scanRectView?.frame = CGRect(x:0, y:0, width:scanSize.width,
                                             height:scanSize.height);
            self.scanRectView?.center = CGPoint( x:UIScreen.main.bounds.midX,
                                                y:UIScreen.main.bounds.midY)
            self.scanRectView?.layer.borderColor = UIColor.green.cgColor
            self.scanRectView?.layer.borderWidth = 1;
            
            //开始捕获
            self.session?.startRunning()
        }catch _ {
            //打印错误消息
            let alertController = UIAlertController(title: "注意",
                                                    message: "カメラの利用を許可していません",
                                                    preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    //スキャン以外ところをマスクを掛け
    func createBackGroundView(scanFram: CGRect) {
        let topView = UIView(frame: CGRect(x: 0, y: 0,  width: UIScreen.main.bounds.size.width, height: scanFram.minY))
        let bottomView = UIView(frame: CGRect(x: 0, y: scanFram.minY + scanFram.height, width: UIScreen.main.bounds.size.width, height: scanFram.minY))
        
        let leftView = UIView(frame: CGRect(x: 0, y: scanFram.minY, width: scanFram.minX, height: scanFram.height))
        let rightView = UIView(frame: CGRect(x: scanFram.minX + scanFram.width, y: scanFram.minY, width: scanFram.minX, height: scanFram.height))
        
        topView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        bottomView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        leftView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        rightView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4
        
        )

        self.view.addSubview(topView)
        self.view.addSubview(bottomView)
        self.view.addSubview(leftView)
        self.view.addSubview(rightView)
    }
    
    //摄像头捕获
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        var stringValue:String?
        if metadataObjects.count > 0 {
            let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            stringValue = metadataObject.stringValue
            if stringValue != nil {
                self.session?.stopRunning()
            }
        }
        self.session?.stopRunning()
        
        if stringValue != nil{
            let vals: Array<String> = (stringValue?.components(separatedBy: ","))!
            let detail = SaleDetailModel()
            if vals.count == 1 {
                detail.itemNo = vals[0]
                detail.itemName = SaleItemManager.find(itemNo: vals[0]).itemName
                if detail.itemName == nil {
                    let alertController = UIAlertController(title: "バーコード", message: "有効なコードではない。", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                        action in
                        self.session?.startRunning()
                    })
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
            }
            else if vals.count == 4 {
                detail.itemNo = vals[0]
                detail.itemName = vals[1]
                detail.price = Int32(vals[2])!
                detail.qty = Int32(vals[3])!
                detail.total = detail.price! * detail.qty!
                //silent
                let soundID = SystemSoundID(kSystemSoundID_Vibrate)
                AudioServicesPlaySystemSound(soundID)
            }
            else{
                let alertController = UIAlertController(title: "QRコード", message: "有効なコードではない。", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                    action in
                    self.session?.startRunning()
                })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            self.setDetail!(detail)
            self.navigationController!.popViewController(animated: true)
        }
        else{
            self.session?.startRunning()
        }
    }
}


