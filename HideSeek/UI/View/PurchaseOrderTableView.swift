//
//  PurchaseOrderTableView.swift
//  HideSeek
//
//  Created by apple on 8/7/16.
//  Copyright © 2016 mj. All rights reserved.
//

import UIKit

class PurchaseOrderTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    let VISIBLE_REFRESH_COUNT = 3;
    
    var orderList: NSMutableArray!
    var tabelViewCell: UITableViewCell!
    var messageWidth: CGFloat!
    var infiniteScrollingView: UIView!
    var loadMoreDelegate: LoadMoreDelegate!
    var screenHeight: CGFloat!
    var grayView: UIView!
    var purchaseDialogController: PurchaseDialogController!
    var screenRect: CGRect!
    var purchaseDelegate: PurchaseDelegate!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.dataSource = self
        self.delegate = self
        self.orderList = NSMutableArray()
        self.setupInfiniteScrollingView()
        self.screenRect = UIScreen.mainScreen().bounds
        self.screenHeight = screenRect.height - 44
        
        self.delaysContentTouches = false
        BaseInfoUtil.cancelButtonDelay(self)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCellWithIdentifier("orderCell")! as! PurchaseOrderTableViewCell
        if orderList.count < indexPath.row + 1 {
            return cell
        }
        
        let purchaseOrder = orderList.objectAtIndex(indexPath.row) as! PurchaseOrder
        cell.purchaseDelegate = purchaseDelegate
        cell.initOrder(purchaseOrder)
        
        BaseInfoUtil.cancelButtonDelay(cell)

        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList.count
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let indexPath = self.indexPathForRowAtPoint(CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y + screenHeight))
        
        if indexPath != nil {
            print(indexPath!.row)
        }
        
        if indexPath != nil && indexPath!.row >= self.orderList.count - VISIBLE_REFRESH_COUNT && self.orderList.count >= 10{
            self.tableFooterView = self.infiniteScrollingView
            self.tableFooterView?.hidden = false
            
            loadMoreDelegate?.loadMore()
        }
    }
    
    func setupInfiniteScrollingView() {
        let screenWidth = UIScreen.mainScreen().bounds.width
        self.infiniteScrollingView = UIView(frame: CGRectMake(0, self.contentSize.height, screenWidth, 40))
        self.infiniteScrollingView!.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.infiniteScrollingView!.backgroundColor = UIColor.whiteColor()
        
        let loadinglabel = UILabel()
        loadinglabel.frame.size = CGSize(width: 100, height: 30)
        loadinglabel.text = NSLocalizedString("LOADING", comment: "Loading...")
        loadinglabel.textAlignment = NSTextAlignment.Center
        loadinglabel.font = UIFont.systemFontOfSize(15.0)
        loadinglabel.center = CGPoint(x: self.infiniteScrollingView.bounds.size.width / 2,
                                      y: self.infiniteScrollingView.bounds.size.height / 2)
        self.infiniteScrollingView!.addSubview(loadinglabel)
    }
}

