//
//  ViewController.swift
//  FJRefresh
//
//  Created by huwei on 2016/12/19.
//  Copyright © 2016年 JUN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var last:CGFloat?
    @IBOutlet var headView: UIView!

    //下拉显示内容
    lazy var refreshBgView:UIView = {
        let refreshBgView = UIView(frame: CGRect(x: 0, y: -UIScreen.main.bounds.size.width*1.5, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width*1.5))
        refreshBgView.backgroundColor = UIColor(patternImage: UIImage(named:"feedflow_refresh_bg@3x.png")!)
        return refreshBgView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        last = 0
        self.refreshData()
        //设置tableview 透明
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.mj_header.beginRefreshing()
        self.tableView.tableHeaderView = headView
    }
    func refreshData() {
        let header = FJRefreshDiyHeader {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.tableView.mj_header.endRefreshing()
            }
        }
        header?.stateLabel.isHidden = true
        header?.lastUpdatedTimeLabel.isHidden = true
        self.tableView.mj_header = header
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.insertSubview(self.refreshBgView, belowSubview: self.tableView)
        self.navigationController?.navigationBar.isTranslucent = true;
        self.navigationController?.navigationBar.barTintColor = UIColor.orange
        //设置导航栏透明度
        self.navigationController?.navigationBar.subviews[0].alpha = 0
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        self.tableView.mj_header.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ViewController:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String(indexPath.row)
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var frame = self.refreshBgView.frame
        frame.origin.y = frame.origin.y - (scrollView.contentOffset.y - last!)
        self.refreshBgView.frame = frame
        last = scrollView.contentOffset.y
        self.view.setNeedsLayout()
        if scrollView.contentOffset.y < 0 {
            self.navigationController?.navigationBar.alpha = 0
        }
        else
        {
            self.navigationController?.navigationBar.alpha = 1
            
        }
        let progress = scrollView.contentOffset.y/200
        self.navigationController?.navigationBar.subviews[0].alpha = progress
    }

}

