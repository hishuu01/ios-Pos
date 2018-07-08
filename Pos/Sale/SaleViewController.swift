//
//  SaleViewController.swift
//  POS
//
//  Created by Yo on 18/3/6.
//  Copyright © 2018年 yo. All rights reserved.
//

import UIKit
import SnapKit
class SaleViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    var pageViewController: UIPageViewController?
    var pageNo: Int = 1
    var saleHead = SaleHeadModel()
    var saleDetails = Array<SaleDetailModel>()
    var pageViews = Array<UIViewController>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "売上"
        self.edgesForExtendedLayout = UIRectEdge()
        self.view.backgroundColor = UIColor.white
        SaleClear()
        
        let addview = AddItemViewController()
        pageViews.append(addview)
        let inputview = SaleInputViewController()
        pageViews.append(inputview)
        let settleview = SaleSettleViewController()
        pageViews.append(settleview)
        let finishview = SaleFinishViewController()
        pageViews.append(finishview)
        
        installUI()
        //installNavigationItem()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /*
        if !(self.navigationController?.viewControllers.contains(self))! {
            let NavVcs = self.navigationController?.childViewControllers;
            let topview = NavVcs?[0] as? HistoryViewController
            topview?.saleDetails.removeAll()
            for detail: SaleDetailModel in saleDetails {
                topview?.saleDetails.append(detail)
            }
        }*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func installNavigationItem() {
        let sumButtonItem = UIBarButtonItem(title: "小計", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SettleMent))
        self.navigationItem.rightBarButtonItem = sumButtonItem
        let addButtonItem = UIBarButtonItem(title: "項目追加", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddItem))
        self.navigationItem.leftBarButtonItem = addButtonItem
    }
    
    func installUI() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController!.delegate = self
        pageViewController!.dataSource = self
        self.addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        
        pageViewController!.view.frame = self.view.frame
        pageViewController!.didMove(toParentViewController: self)
        
        let startview: SaleInputViewController = pageViews[1] as! SaleInputViewController
        pageViewController!.setViewControllers([startview], direction: .forward, animated: true, completion: {done in })
    }
    
 
    @objc func AddItem(direct: UIPageViewControllerNavigationDirection) {
        
        let additem = pageViews[0] as! AddItemViewController
        self.pageNo = 0
        pageViewController!.setViewControllers([additem], direction: direct, animated: true, completion: {done in })
    }
    
    func SaleInput(direct: UIPageViewControllerNavigationDirection) {
        
        let saleinput = pageViews[1] as! SaleInputViewController
        self.pageNo = 1
        pageViewController!.setViewControllers([saleinput], direction: direct, animated: true, completion: {done in })
    }
    @objc func SettleMent(direct: UIPageViewControllerNavigationDirection) {
        //if saleHead.qty == 0 {
        //    UIAlertController.showAlert(message: "明細が未登録です。", in: self)
        //    return
        //}
        
        let settle = pageViews[2] as! SaleSettleViewController
        self.pageNo = 2
        pageViewController!.setViewControllers([settle], direction: direct, animated: true, completion: {done in })
    }
    
    func Finish(direct: UIPageViewControllerNavigationDirection) {
        let finish = pageViews[3] as! SaleFinishViewController
        self.pageNo = 3
        pageViewController!.setViewControllers([finish], direction: direct, animated: true, completion: {done in })
    }
    
    func CalcTotal(){
        saleHead.qty = 0
        saleHead.total = 0
        for detail : SaleDetailModel in saleDetails{
            saleHead.qty = saleHead.qty! + detail.qty!
            saleHead.total = saleHead.total! + detail.total!
        }
    }
    // MARK: - Page View Controller Data Source
    //这个协议方法会在用户向前翻页时调用 这里需要将要展示的视图控制器返回 如果返回nil 则不能够再向前翻页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var idx = viewController.view.tag
        if (idx != 0 && idx != 3) {
            idx -= 1
            self.pageNo = idx
            return pageViews[idx]
        }
        return nil
    }
    //这个协议方法会在用户向后翻页时调用 这里需要将要展示的视图控制器返回 如果返回nil 则不能够在向后翻页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var idx = viewController.view.tag
        if idx < 2 {
            idx += 1
            self.pageNo = idx
            return pageViews[idx]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finish: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if finish && !completed {
            let idx = previousViewControllers.last?.view.tag
            switch (idx!) {
            case 0:
                let additem = pageViews[idx!] as! AddItemViewController
                additem.installNavigationItem()
            case 1:
                let saleinput = pageViews[idx!] as! SaleInputViewController
                saleinput.installNavigationItem()
            case 2:
                let settle = pageViews[idx!] as! SaleSettleViewController
                settle.installNavigationItem()
            case 3:
                let finish = pageViews[idx!] as! SaleFinishViewController
                finish.installNavigationItem()
            default:
                break;
            }

        }
 

    }
    //设置页码数
    func presentationCount(for pageViewController: UIPageViewController) -> Int{
        return pageViews.count
    }
    //设置出初始选中的页码点
    func presentationIndex(for pageViewController: UIPageViewController) -> Int{
        return self.pageNo
    }
    
    func SaleClear(){
        saleHead = SaleHeadModel()
        saleHead.qty = 0
        saleHead.total = 0
        saleHead.payNo = "1"
        saleHead.payName = CodeNameManager.getName(groupno: "01", code: saleHead.payNo!)
        saleDetails = Array<SaleDetailModel>()
    }
}

