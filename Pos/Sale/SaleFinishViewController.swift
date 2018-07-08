//
//  SaleViewController.swift
//  POS
//
//  Created by Yo on 18/3/6.
//  Copyright © 2018年 yo. All rights reserved.
//

import UIKit
import SnapKit
class SaleFinishViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UIPrintInteractionControllerDelegate  {

    var saleView: SaleViewController?
    var sumQtyLabel: UILabel?
    var sumTotalLabel: UILabel?
    var itemCell:UITableView?
    var saleHead = SaleHeadModel()
    var saleDetails = Array<SaleDetailModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "決済完了"
        self.view.tag = 3
        self.view.backgroundColor = UIColor.white
        self.edgesForExtendedLayout = UIRectEdge()
        installUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saleView = self.parent!.parent! as? SaleViewController
        saleHead = saleView!.saleHead
        saleDetails = saleView!.saleDetails
        DispTotal()
        installNavigationItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func installNavigationItem() {
        saleView?.title = self.title
        let nItem = UIBarButtonItem(title: "印刷", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.printSlip))
        let leftItem = UIBarButtonItem(image: UIImage(named: "ImageQR"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.QRCode))
        saleView?.navigationItem.leftBarButtonItem = leftItem
        saleView?.navigationItem.rightBarButtonItems = [nItem]
    }
    
    func installUI() {
        sumQtyLabel = UILabel()
        self.view.addSubview(sumQtyLabel!)
        sumQtyLabel?.font = UIFont.boldSystemFont(ofSize: 32)
        sumQtyLabel?.snp.makeConstraints({ (maker) in
            maker.top.equalTo(10)
            maker.left.equalTo(16)
            maker.width.equalTo(100)
            maker.height.equalTo(40)
        })

        sumTotalLabel = UILabel()
        self.view.addSubview(sumTotalLabel!)
        sumTotalLabel?.textAlignment = NSTextAlignment.right
        sumTotalLabel?.font = UIFont.boldSystemFont(ofSize: 32)
        sumTotalLabel?.snp.makeConstraints({ (maker) in
            maker.top.equalTo(10)
            maker.left.equalTo(sumQtyLabel!.snp.right).offset(1)
            maker.right.equalTo(-10)
            maker.height.equalTo(40)
        })
        
        let line1 = UIView()
        line1.backgroundColor = UIColor.gray
        self.view.addSubview(line1)
        line1.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.equalTo(sumQtyLabel!.snp.bottom).offset(5)
            maker.right.equalTo(0)
            maker.height.equalTo(0.5)
        }
        
        itemCell = UITableView()
        self.view.addSubview(itemCell!)
        itemCell?.delegate = self
        itemCell?.dataSource = self
        //itemCell?.separatorStyle = UITableViewCellSeparatorStyle.none
        itemCell?.snp.makeConstraints({ (maker) in
            maker.top.equalTo(line1.snp.bottom).offset(5)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        })
        itemCell?.register(UINib.init(nibName: "InputTableViewCell", bundle: nil), forCellReuseIdentifier: "InputTableViewCellId")
        
   
        let newButton =  UIButton(type: UIButtonType.system)
        //newButton.tintColor = UIColor.white
        //newButton.backgroundColor = UIColor.red
        //newButton.layer.cornerRadius = newButton.frame.width / 2
        newButton.setTitle("新しい売上入力", for: UIControlState())
        newButton.tintColor = UIColor.red
        newButton.layer.cornerRadius = 5
        newButton.backgroundColor = UIColor(red: 230/255, green: 180/255, blue: 80/255, alpha: 1)
        self.view.addSubview(newButton)
        newButton.snp.makeConstraints { (maker) in
            maker.width.equalTo(200)
            maker.height.equalTo(40)
            maker.centerX.equalTo(self.view)
            maker.bottom.equalTo(0)
        }

        newButton.addTarget(self, action: #selector(self.NewSale), for: UIControlEvents.touchUpInside)

    }
    
    func DispTotal(){
        sumQtyLabel?.text = String(format:"%d",saleHead.qty!) + "点"
        sumTotalLabel?.text = Common.formatNumberStr(num:saleHead.total!) + "円"
    }

    @objc func NewSale(){
        saleView?.SaleClear()
        saleView?.SaleInput(direct: .reverse)
    }
    
    @objc func QRCode(){
        let qrView = SaleQRViewController()
        qrView.saleHead = self.saleHead
        qrView.saleDetails = self.saleDetails
        self.navigationController?.pushViewController(qrView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //获取到载体Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "InputTableViewCellId", for: indexPath) as! InputTableViewCell
        cell.TextField.textAlignment = .right
        cell.TextField.isEnabled = false
        switch (indexPath.row) {
        case 0:
            cell.Label.text  = "決済種別"
            cell.TextField.text = self.saleHead.payName
        case 1:
            cell.Label.text = "お預り"
            cell.Label.font = UIFont.systemFont(ofSize: 24)
            cell.TextField.text = Common.formatNumberStr(num:saleHead.payAmount!)
            cell.TextField.font = UIFont.systemFont(ofSize: 24)
        case 2:
            cell.Label.text = "お釣り"
            cell.Label.font = UIFont.systemFont(ofSize: 24)
            cell.TextField.font = UIFont.systemFont(ofSize: 24)
            cell.TextField.text = Common.formatNumberStr(num:saleHead.change!)
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func printSlip(sender: AnyObject) {
        // 打印控制器
        let printController = UIPrintInteractionController.shared
        // 打印任务相关信息
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = UIPrintInfoOutputType.general
        printInfo.jobName = "sale slip"
        printController.printInfo = printInfo
        
        //table
        var printText = "<table id='table1' border='0' cellspacing='0'"
            + "cellpadding='0' style='font-size:12px;border-collapse: collapse; "
            + "margin: 0px; padding: 0px; border-spacing: 0px;'>"
            + "<tbody>"
        //logo
        printText += "<tr><td colspan='3' style='text-align:center;font-size:16px'>売上伝票</td></tr>"
        //head
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日 HH時mm分"
        printText += "<tr>"
        printText += "<td colspan='2'>" + dformatter.string(from: Date()) + "</td>"
        printText += "<td style='text-align:right'>No." + saleHead.slipNo! + "</td>"
        printText += "</tr>"
        printText += "<tr>"
        printText += "<td colspan='3' style='font-size:10px'>------------------------------------------------------------------------------</td>"
        printText += "</tr>"
        //detail
        for detail:SaleDetailModel in saleDetails {
            printText += "<tr>"
            printText += "<td style='width:100px'>" + detail.itemName! + "</td>"
            printText += "<td style='width:80px'>" + Common.formatNumberStr(num: detail.price!) + "X\(detail.qty!)</td>"
            printText += "<td style='width:80px;text-align:right'>" + Common.formatNumberStr(num: detail.total!) + "</td>"
            printText += "</tr>"
        }
        //sum
        printText += "<tr>"
        printText += "<td colspan='2' style='font-size:16px'>合計</td>"
        printText += "<td style='font-size:16px;text-align:right'>" + "¥" + Common.formatNumberStr(num: saleHead.total!) + "</td>"
        printText += "</tr>"
        //預かり
        printText += "<tr>"
        printText += "<td colspan='2' style='font-size:16px'>お預り</td>"
        printText += "<td style='font-size:16px;text-align:right'>" + "¥" + Common.formatNumberStr(num: saleHead.payAmount!) + "</td>"
        printText += "</tr>"
        //釣り銭
        printText += "<tr>"
        printText += "<td colspan='2' style='font-size:16px'>お釣り</td>"
        printText += "<td style='font-size:16px;text-align:right'>" + "¥" + Common.formatNumberStr(num: saleHead.change!) + "</td>"
        printText += "</tr>"
        printText += "</tbody></table>"
        // 格式化打印文本
        //let formatter = UISimpleTextPrintFormatter(text: printText)
        let formatter = UIMarkupTextPrintFormatter(markupText: printText)
        // 设置页面Insets边距
        formatter.contentInsets = UIEdgeInsets(top: 36, left: 36, bottom: 36, right: 36)
        printController.printFormatter = formatter
        //设置打印控制器代理
        printController.delegate = self
        
        // 提供打印界面让用户选择打印机和副本的数量
        printController.present(animated: true, completionHandler: nil)
    }
    
    //设置打印尺寸
    func printInteractionController(choosePaper paperList: [UIPrintPaper]) -> UIPrintPaper {
        //A6尺寸
        let pageSize:CGSize = CGSize(width: 10.5 / 2.54 * 72, height: 14.8 / 2.54 * 72)
        let paper = UIPrintPaper.bestPaper(forPageSize: pageSize, withPapersFrom: paperList)
        
        return paper
    }
    
}

