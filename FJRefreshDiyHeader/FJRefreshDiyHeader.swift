//
//  FJRefreshDiyHeader.swift
//  FJRefresh
//
//  Created by huwei on 2016/12/19.
//  Copyright © 2016年 JUN. All rights reserved.
//

import UIKit
import MJRefresh

class FJRefreshDiyHeader: MJRefreshStateHeader {

    lazy var activityShapLayer:CAShapeLayer = {
        let center = CGPoint(x: 15, y: 15)
        let shaplayer = CAShapeLayer()
        shaplayer.path = UIBezierPath(arcCenter: CGPoint(x:0,y:0), radius: 10, startAngle: 0, endAngle: CGFloat(M_PI)*2-0.6, clockwise: true).cgPath
        shaplayer.strokeColor = self.Color(95, g: 164, b: 236).cgColor
        shaplayer.fillColor = UIColor.clear.cgColor
        shaplayer.lineWidth = 2
        shaplayer.position = center
        return shaplayer
    }()
    lazy var loadingView: UIView = {
        let loadingView = UIView(frame: CGRect(x: self.frame.size.width/2 - 15, y: self.frame.size.height/2 - 15, width: 30, height: 30))
        loadingView.layer.addSublayer(self.activityShapLayer)
        return loadingView
    }()
    func stopAnimations() {
        self.activityShapLayer.removeAllAnimations()
    }
    func startAnimations() {
        self.addAnimation()
    }
    func addAnimation() {
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation.z";
        animation.duration = 1.0;
        animation.fromValue = 0;
        animation.toValue = 2*M_PI;
        animation.repeatCount = 10000;
        animation.isRemovedOnCompletion = false;
        self.activityShapLayer.add(animation, forKey: "rotation")
    }
    override var state: MJRefreshState{
        didSet {
            //闲置状态
            if state == MJRefreshState.idle {
                print("闲置状态")
                self.stopAnimations()
                
            }
                //松开就可以进行刷新的状态
            else if state == MJRefreshState.pulling
            {
                print("松开就可以进行刷新的状态")
                
            }
                //正在刷新状态
            else if state == MJRefreshState.refreshing
            {
                print("正在刷新状态")
                self.startAnimations()
            }
            else if state == MJRefreshState.noMoreData
            {
                
            }
        }
    }
    
    override func prepare() {
        super.prepare()
        
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        self.addSubview(loadingView)
        
    }
    func Color(_ r:Float,g:Float,b:Float) -> UIColor {
        return UIColor(colorLiteralRed: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }

}
