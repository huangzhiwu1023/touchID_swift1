//
//  WSGetureLockView.swift
//  touchID_swift
//
//  Created by Kaven on 17/2/20.
//  Copyright © 2017年 Kaven. All rights reserved.
//

import UIKit

class WSGetureLockView: UIView {

    var gestureLockDelegate : GestureLockProtocol?
    let screenWidth = UIScreen.main.bounds.size.width
    var btnArray : [UIButton] = [UIButton]()
    
    var selectBtnTagArray : [Int] = [Int]()
    var gesturePoint : CGPoint = CGPoint()
    let btnWh : CGFloat = 70.0
    let btnImgNormal = "gesture_node_normal"
    let btnImgSelected =  "gesture_node_selected"

    
    override init(frame:CGRect) {
    super.init(frame: frame)
    self.backgroundColor = UIColor.white
        initBtn()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        drawBtn()
    }
    
}

//设置按钮
extension WSGetureLockView {
    func initBtn() {
    
        for i  in 0...8 {
        let row = i / 3 //行
        let loc = i % 3 //列
        
            // 间距
            let btnSpace = (screenWidth - 3 * btnWh)/4
            let btnX = btnSpace + (btnWh + btnSpace) * CGFloat(loc)
            let btnY = 150 + btnSpace + (btnWh + btnSpace) * CGFloat(row)
            
            let gestureNodesBtn = UIButton(frame:CGRect(x: btnX, y: btnY, width: btnWh, height: btnWh))
            gestureNodesBtn.tag = i
            gestureNodesBtn.isUserInteractionEnabled = false
            gestureNodesBtn.setImage(UIImage.init(named: btnImgNormal), for: .normal)
            addSubview(gestureNodesBtn)
            btnArray.append(gestureNodesBtn)
        }
        
        
    }
}

//画的过程
extension WSGetureLockView {
    func drawBtn() {
       
        let context = UIGraphicsGetCurrentContext()
        
        var i = 0
        
        for tag in selectBtnTagArray {
            if 0 == i {
                //开始设置用直线的起点坐标
                context?.move(to:CGPoint(x: btnArray[tag].center.x, y:  btnArray[tag].center.y))
           
            }else {
            //画直线，设置有终点线的指标
                context?.addLine(to: CGPoint(x: btnArray[tag].center.x, y:  btnArray[tag].center.y))
            }
             i = i+1
        }
        
        // 如果选中的是节点，就取跟着手指的滑动画线
        if (selectBtnTagArray.count > 0) {
          //移除最后一跳多余的线
            if gesturePoint != CGPoint(x: 0, y: 0) {
            context?.addLine(to: CGPoint(x: gesturePoint.x, y: gesturePoint.y))
            }
        }
        
        context?.setLineWidth(10)
        context?.setLineJoin(.round)//相交处
         context?.setLineCap(.round)//两端
        context?.setStrokeColor(UIColor.orange.cgColor)
        context?.strokePath()//hua
    }

}

//画的手势代理
extension WSGetureLockView {

    //当手触摸屏幕
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectBtnTagArray.removeAll()
        touchesChange(touch:touches)
    }
    
    //手移动
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesChange(touch:touches)
    }
    
    //取消的时候
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    //  手离开屏幕
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        var alertTitle =  "请设置正确的手势"
        var alertMessage = "手势密码不能少于4个"
        var isSuccess = false
        
        //大于4位的密码
        if selectBtnTagArray.count >= 4 {
            alertTitle =  "手势密码设置成功"
            isSuccess = true
            alertMessage = "密码为：\(selectBtnTagArray)"
        }
        
        gestureLockDelegate!.gestureLockSuccess(isSuccess: isSuccess, title: alertTitle, message: alertMessage)
        
        gesturePoint = .zero;
        self.setNeedsDisplay()
    }
    

}

//计算滑点位置
extension WSGetureLockView {
     func touchesChange(touch:Set<UITouch>) {
        //获取触摸对象的位置指标来实现
        gesturePoint = (touch.first?.location(in: self))!
        
        for btn in btnArray {
            
            //判断手指的坐标是否在button的坐标里
            if !selectBtnTagArray.contains(btn.tag) && btn.frame.contains(gesturePoint){
                //处理跳跃连线
                var lineCenterPoint:CGPoint = CGPoint()
                if selectBtnTagArray.count > 0 {
                    let point : CGPoint = btnArray[selectBtnTagArray.last!].frame.origin
                    lineCenterPoint = centerPoint(btn.frame.origin, point)
                }
                
                //保存中间的跳跃过的节点
                
                for btn in btnArray {
                    if !selectBtnTagArray.contains(btn.tag) && btn.frame.contains(lineCenterPoint){
                        btn.setImage(UIImage(named: btnImgSelected), for: .normal)
                        selectBtnTagArray.append(btn.tag)
                    }
                }
                //保存划过的按钮的tag
                selectBtnTagArray.append(btn.tag)
                btn.setImage(UIImage(named: btnImgSelected), for: .normal)
                
            }
        }
        // 调用draw
        self.setNeedsDisplay()
    }
    
    //计算2个节点中心的坐标
    private func centerPoint(_ startPoint:CGPoint ,_ endPoint: CGPoint) -> CGPoint {
        let rightPoint = startPoint.x > endPoint.x ? startPoint.x : endPoint.x
        let leftPoint = startPoint.x < endPoint.x ? startPoint.x : endPoint.x
        
        let topPoint = startPoint.y > endPoint.y ? startPoint.y : endPoint.y
        let bottomPoint = startPoint.y < endPoint.y ? startPoint.y : endPoint.y
        
        //x坐标： leftPoint +（rightPoint-leftPoint)/2 = (rightPoint+leftPoint)/2
        return CGPoint(x: (rightPoint + leftPoint)/2 + btnWh/2,  y: (topPoint + bottomPoint)/2 + btnWh/2)
    }
    
    //复原
    func recoverNodeStatus() {
        selectBtnTagArray.removeAll()
        for btn in btnArray {
            btn.setImage(UIImage(named: btnImgNormal), for: .normal)
        }
        self.setNeedsDisplay()
    }
}

