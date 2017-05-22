//
//  WSGetureLockVC.swift
//  touchID_swift
//
//  Created by Kaven on 17/2/20.
//  Copyright © 2017年 Kaven. All rights reserved.
//

import UIKit

protocol GestureLockProtocol {
    func gestureLockSuccess(isSuccess:Bool, title: String, message: String)
}

class WSGetureLockVC: UIViewController,GestureLockProtocol {
let gestureLockView = WSGetureLockView()
    
    internal func gestureLockSuccess(isSuccess: Bool, title: String, message: String) {
        if isSuccess == true  {
        print("设置手势密码成功")
        }else {
        print("设置手势密码失败")
        }
        let alert: UIAlertController = UIAlertController(title:title, message:message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: {action in
            print("alert确定")
            
            self.gestureLockView.recoverNodeStatus()
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
  
        gestureLockView.gestureLockDelegate = self
        self.view = gestureLockView
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
