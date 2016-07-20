//
//  ViewController.swift
//  MRPullToRefreshLoadMore
//
//  Created by Mojca Rojko on 07/15/2016.
//  Copyright (c) 2016 Mojca Rojko. All rights reserved.
//

import UIKit
import MRPullToRefreshLoadMore

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MRPullToRefreshLoadMoreDelegate {

    @IBOutlet weak var tableView: MRTableView!
    
    var moreLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.pullToRefresh.pullToRefreshLoadMoreDelegate = self
        tableView.pullToRefresh.indicatorTintColor = UIColor.lightGrayColor()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: TableView Delegate/DataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (!moreLoaded) {
            return 20
        } else {
            return 40
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell")!
        cell.textLabel!.text = "Random"
        cell.textLabel!.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    // MARK: MRPullToRefreshLoadMoreDelegate functions
    
    func viewShouldRefresh(scrollView:UIScrollView) {
        // if you need a tableview instance
        guard let tableView = scrollView as? MRTableView else {
            return
        }
        
        print("view should refresh")
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            tableView.pullToRefresh.setPullState(MRPullToRefreshLoadMore.ViewState.Normal)
        }
        
    }
    
    func viewShouldLoadMore(scrollView:UIScrollView) {
        // if you need a tableview instance
        guard let tableView = scrollView as? MRTableView else {
            return
        }
        
        print("view should load more")
        moreLoaded = true
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            tableView.reloadData()
            tableView.pullToRefresh.setLoadMoreState(MRPullToRefreshLoadMore.ViewState.Normal)
        }
    }
}

