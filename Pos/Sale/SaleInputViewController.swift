//
//  SaleView.swift
//  NoteBook
//
//  Created by yo on 18/3/5.
//  Copyright © 2018年 yo. All rights reserved.
//

import UIKit

class SaleInputViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var saleView: SaleViewController?
    var headView: UIView?
    var sumQtyLabel: UILabel?
    var sumTotalLabel: UILabel?
    var showImage: UIImageView?
    var showDetail: Bool?
    var listView: UITableView?
    var Details = Array<SaleHistoryModel>()
    
    var saleHead = SaleHeadModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "売上入力"
        self.view.tag = 1
        self.edgesForExtendedLayout = UIRectEdge()
        installUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saleView = self.parent!.parent! as? SaleViewController
        saleHead = saleView!.saleHead
        installNavigationItem()
        DispTotal()
        Details = SaleHistoryManager.find()
        showDetail = false
        listView?.reloadData()
    }
    
    func installUI() {

        headView = UIView(frame: CGRect(x:0, y:0, width:self.view.frame.width, height:56))
        self.view.addSubview(headView!)
        
        sumQtyLabel = UILabel()
        headView?.addSubview(sumQtyLabel!)
        sumQtyLabel?.font = UIFont.boldSystemFont(ofSize: 32)
        sumQtyLabel?.snp.makeConstraints({ (maker) in
            maker.top.equalTo(10)
            maker.left.equalTo(16)
            maker.width.equalTo(100)
            maker.height.equalTo(40)
        })
        
        sumTotalLabel = UILabel()
        headView?.addSubview(sumTotalLabel!)
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
        headView?.addSubview(line1)
        line1.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.equalTo(sumQtyLabel!.snp.bottom).offset(5)
            maker.right.equalTo(0)
            maker.height.equalTo(0.5)
        }
        
        showImage = UIImageView(image: UIImage(named: "ImageArrow"))
        headView?.addSubview(showImage!)
        showImage?.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.view)
            maker.bottom.equalTo(line1.snp.bottom).offset(-2)
        }
        //タップイベント追加
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.headViewClick(sender:)))
        headView?.isUserInteractionEnabled = true
        headView?.addGestureRecognizer(tapGesture)

        //listView = UITableView(frame: self.view.frame, style: .plain)
        listView = UITableView()
        self.view.addSubview(listView!)
        listView?.snp.makeConstraints({ (maker) in
            maker.top.equalTo(line1.snp.bottom).offset(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        })
        listView?.delegate = self
        listView?.dataSource = self
        //定義したcellを登録
        listView?.register(UINib.init(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "SaleTableViewCellId")
        
    }
    
    @objc func headViewClick(sender: UITapGestureRecognizer) -> Void {
        let img = UIImage(named: "ImageArrow")
        if showDetail! {
            showDetail = false
            showImage?.image = img
        }else{
            showDetail = true
            showImage?.image = UIImage(cgImage: (img?.cgImage)!, scale: 1, orientation: UIImageOrientation.down)
        }
        let set:IndexSet = IndexSet.init(integer: 0)
        listView?.reloadSections(set, with: UITableViewRowAnimation.fade)
    }
    
    func CalcTotal(){
        saleHead.qty = 0
        saleHead.total = 0
        for detail : SaleDetailModel in saleView!.saleDetails{
            saleHead.qty = saleHead.qty! + detail.qty!
            saleHead.total = saleHead.total! + detail.total!
        }
    }
    
    func DispTotal(){
        sumQtyLabel?.text = String(format:"%d",saleHead.qty!) + "点"
        sumTotalLabel?.text = Common.formatNumberStr(num:saleHead.total!) + "円"
    }
    
    func installNavigationItem(){
        saleView?.title = self.title
        if listView?.isEditing == true {
            FinishNavigationItem()
        }
        else{
            EditNavigationItem()
        }
    }
    func EditNavigationItem() {
        let editButtonItem = UIBarButtonItem(title: "編集", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.EntryEdit))
        //let sumButtonItem = UIBarButtonItem(title: "小計", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.SettleMent))
        let sumbtn = UIButton()
        sumbtn.setTitle("小計", for: .normal)
        sumbtn.setTitleColor(saleView?.navigationController?.navigationBar.tintColor, for: .normal)
        sumbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        sumbtn.addTarget(self, action: #selector(self.SettleMent), for: UIControlEvents.touchUpInside)
        let sumButtonItem = UIBarButtonItem(customView: sumbtn)
        saleView?.navigationItem.rightBarButtonItems = [sumButtonItem,editButtonItem]
        let addButtonItem = UIBarButtonItem(title: "項目追加", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.AddItem))
        saleView?.navigationItem.leftBarButtonItem = addButtonItem
    }
    
    func FinishNavigationItem() {
        let barButtonItem = UIBarButtonItem(title: "完了", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.ExitEdit))
        saleView?.navigationItem.rightBarButtonItems = [barButtonItem]
        saleView?.navigationItem.leftBarButtonItem = nil
    }

    @objc func EntryEdit() {
        listView!.isEditing = true
        FinishNavigationItem()
    }

    @objc func ExitEdit() {
        listView!.isEditing = false
        EditNavigationItem()
        SaleHistoryManager.deleteAll()
        for idx in 1...Details.count {
            let model = Details[Details.count-idx]
            model.row = nil
            SaleHistoryManager.insert(detail: model)
        }
    }
    @objc func SettleMent(){
        saleView!.SettleMent(direct: .forward)
    }
    
    @objc func AddItem(){
        saleView!.AddItem(direct: .reverse)
    }
    //Mask: TableView Delegate
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        }
        return "ひな形"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /*
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let title = UILabel()
            title.font = UIFont.boldSystemFont(ofSize: 14)
            title.text = "売上ひな形"
            title.backgroundColor = UIColor.groupTableViewBackground
            
            return title
        }
        
        let totalview = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        return totalview
    }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if showDetail! {
                return saleView!.saleDetails.count
            }else{
                return 0
            }
        }
        return Details.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SaleTableViewCellId", for: indexPath) as! DetailTableViewCell
        
        if indexPath.section == 0 {
            let model = saleView!.saleDetails[indexPath.row]
            cell.ItemName.text = model.itemName!
            cell.price.text = Common.formatNumberStr(num: model.price!)
            cell.qty.text = Common.formatNumberStr(num: model.qty!)
            cell.total.text = Common.formatNumberStr(num: model.total!)
        }
        else{
            let model = Details[indexPath.row]
            cell.ItemName.text = model.itemName!
            cell.price.text = Common.formatNumberStr(num: model.price!)
            cell.qty.text = Common.formatNumberStr(num: model.qty!)
            cell.total.text = Common.formatNumberStr(num: model.total!)
            cell.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.5)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            if indexPath.section == 0 {
                saleView!.saleDetails.remove(at: indexPath.row)
                CalcTotal()
                DispTotal()
            }
            else{
                Details.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
        }
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return !showDetail!
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section == destinationIndexPath.section {
            if sourceIndexPath.section == 0 {
                let moveitem = saleView!.saleDetails[sourceIndexPath.row]
                saleView!.saleDetails.remove(at: sourceIndexPath.row)
                saleView!.saleDetails.insert(moveitem, at: destinationIndexPath.row)
            }
            else{
                let moveitem = Details[sourceIndexPath.row]
                Details.remove(at: sourceIndexPath.row)
                Details.insert(moveitem, at: destinationIndexPath.row)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            let detail = Details[indexPath.row]
            self.saleView!.saleDetails.append(setDetail(model: detail))
            CalcTotal()
            DispTotal()
            let set:IndexSet = IndexSet.init(integer: 0)
            listView?.reloadSections(set, with: UITableViewRowAnimation.fade)
        }
    }
    
    func setDetail(model: SaleHistoryModel) -> SaleDetailModel {
        let saledetail = SaleDetailModel()
        saledetail.itemNo = model.itemNo!
        saledetail.itemName = model.itemName!
        saledetail.price = model.price!
        saledetail.qty = model.qty!
        saledetail.total = model.price! * model.qty!
        return saledetail
    }
}

