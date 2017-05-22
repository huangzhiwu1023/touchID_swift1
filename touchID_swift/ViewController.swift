//
//  ViewController.swift
//  touchID_swift
//
//  Created by Kaven on 17/2/20.
//  Copyright © 2017年 Kaven. All rights reserved.
//

import UIKit
import LocalAuthentication //Touch库


class ViewController: UIViewController {

    let fingerprintLock = UIButton()//指纹登录
    let keyLock = UIButton()//设置密码
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}






// 设置界面

extension ViewController {
//  设置界面
    func setUI() {
    
        //指纹解锁
        fingerprintLock.setTitle("指纹解锁", for: .normal)
        fingerprintLock.setTitleColor(UIColor.black, for: .normal)
        fingerprintLock.backgroundColor = UIColor.orange
        fingerprintLock.clipsToBounds = true
        fingerprintLock.layer.cornerRadius = 5
        fingerprintLock.addTarget(self, action: #selector(finger), for: .touchUpInside)
        
        //指纹解锁
        keyLock.setTitle("密码解锁", for: .normal)
        keyLock.setTitleColor(UIColor.black, for: .normal)
        keyLock.backgroundColor = UIColor.orange
        keyLock.clipsToBounds = true
        keyLock.layer.cornerRadius = 5
        keyLock.addTarget(self, action: #selector(goKey), for: .touchUpInside)
        
        view.addSubview(fingerprintLock)
        view.addSubview(keyLock)
        
        fingerprintLock.frame = CGRect(x: 80, y: 250, width: 200, height: 40)
        keyLock.frame = CGRect(x: 80, y: 320, width: 200, height: 40)
    }
    
    // 进入指纹
    func finger() {
    print("进入指纹")
        fingerLock()
    }
    
    //进入密码解锁
    func goKey() {
        let vc = WSGetureLockVC()
        self.present(vc, animated: true, completion: nil)
       print("进入密码解锁")
    }
    
    func mAlert(title:String,message:String?) {
        let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "确定")
        alert.show()
    }
    
}

// 指纹实现

extension ViewController {

    func fingerLock(){
        //  创建laContext
    let context = LAContext()
        var error : NSError?
        //设置这个属性指纹输入失败之后弹出的框
      context.localizedFallbackTitle = "没有忘记密码"
        //判断是否支持指纹识别
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
        
            print("支持指纹识别")
            
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: " 请按Home键指纹解锁", reply: { (success, error) in
                if success {
                    print("解锁成功")
                    
                  OperationQueue.main.addOperation({ 
                    // 刷新主线程的东西
                    self.fingerprintLock.backgroundColor = UIColor.purple
                    self.mAlert(title: "", message: "解锁成功")
                  })
                    
                }
                else{
                    OperationQueue.main.addOperation({
                        // 刷新主线程的东西
                       // self.fingerprintLock.backgroundColor = UIColor.purple
                        self.mAlert(title: "", message: "解锁失败，请用密码解锁")
                  })
                    
                print("\(error?.localizedDescription)")
                  let e = error as! NSError
                    switch e.code {
                    
                    case LAError.authenticationFailed.rawValue:
                        print("授权失败")
                    case LAError.userCancel.rawValue:
                        print("用户取消验证Touch ID")
                    case LAError.userFallback.rawValue:
                        print("用户点击 输入密码，切换主线程处理")
                        OperationQueue.main.addOperation({
                            // 刷新主线程的东西
                            self.showPasswordAlert()
                        })
                    case LAError.systemCancel.rawValue:
                        print("切换到其他APP，系统取消验证Touch ID")
                    case LAError.passcodeNotSet.rawValue:
                        print("系统未设置密码")
                    case LAError.touchIDNotAvailable.rawValue:
                        print("设备Touch ID不可用，例如未打开")
                    case LAError.touchIDNotEnrolled.rawValue:
                        print("设备Touch ID不可用，用户未录入")
                    case LAError.touchIDLockout.rawValue:
                        print("Touch ID输入错误多次，已被锁")
                    case LAError.appCancel.rawValue:
                        print("用户除外的APP挂起，如电话接入等切换到了其他APP")
                    default:
                        print("其他情况")
                        OperationQueue.main.addOperation({
                            // 刷新主线程的东西
                            self.showPasswordAlert()
                        })


                       //
                    }
                    
                    
                }
                
            })
            
        }
        
        else {
        print("不支持指纹识别")
            
        }
    }
    
    
    private func showPasswordAlert() {
        let passwordAlert: UIAlertController = UIAlertController(title:"指纹验证选择输入密码", message:"请输入手机密码", preferredStyle:.alert)
        passwordAlert.addTextField(configurationHandler: { (textField: UITextField) in
            textField.isSecureTextEntry = true
        })
        
        passwordAlert.addAction(UIAlertAction(title: "确定", style: .default, handler: {action in
            let password = passwordAlert.textFields?.first?.text
            if let pw = password {
                print("输入密码正确，密码为： \(pw)")
            }
        }))
        
        passwordAlert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: {action in
            print("取消输入密码")
        }))
        
        self.present(passwordAlert, animated: true, completion: nil)
    }

}

