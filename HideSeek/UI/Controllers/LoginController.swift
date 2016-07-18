//
//  LoginController.swift
//  HideSeek
//
//  Created by apple on 6/24/16.
//  Copyright © 2016 mj. All rights reserved.
//

import UIKit
import MBProgressHUD
import AFNetworking

class LoginController: UIViewController {
    let HtmlType = "text/html"
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var manager: AFHTTPRequestOperationManager!
    var phone: String = ""
    var password: String = ""
    
    @IBAction func loginBtnClicked(sender: AnyObject) {
        let paramDict = ["phone": phone, "password": password]
        manager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes =  NSSet().setByAddingObject(HtmlType)
        
        var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = NSLocalizedString("LOADING_HINT", comment: "Please wait...")
        hud.dimBackground = true
        
        manager.POST(UrlParam.LOGIN_URL,
                    parameters: paramDict,
                    success: { (operation, responseObject) in
                        let response = responseObject as! NSDictionary
                        print("JSON: " + responseObject.description!)
                        
                        self.setInfoFromCallback(response)
                        hud.removeFromSuperview()
                        hud = nil
            },
                    failure: { (operation, error) in
                        print("Error: " + error.localizedDescription)
                        let errorMessage = ErrorMessageFactory.get(CodeParam.ERROR_VOLLEY_CODE)
                        HudToastFactory.show(errorMessage, view: self.view)
                        hud.removeFromSuperview()
                        hud = nil
        })
    }
    
    @IBAction func phoneTextChanged(sender: AnyObject) {
        checkIfLoginEnabled()
    }
    
    @IBAction func passwordTextChanged(sender: AnyObject) {
        checkIfLoginEnabled()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView() {
        loginBtn.setBackgroundColor("#fccb05", selectedColorStr: "#ffa200", disabledColorStr: "#bab8b8")
        loginBtn.layer.cornerRadius = 5
        loginBtn.layer.masksToBounds = true
    }
    
    func checkIfLoginEnabled() {
        phone = phoneTextField.text!
        password = passwordTextField.text!
        
        loginBtn.enabled = !phone.isEmpty && !password.isEmpty
    }
    
    func setInfoFromCallback(response: NSDictionary) {
        let code = (response["code"] as! NSString).integerValue
        
        if code == CodeParam.SUCCESS {
            UserCache.instance.setUser(response["result"] as! NSDictionary)
            self.dismissViewControllerAnimated(true, completion: nil)
            self.closure()
        } else {
            let errorMessage = ErrorMessageFactory.get(code)
            HudToastFactory.show(errorMessage, view: self.view)
        }
    }
    
    typealias Closure = () ->Void
    var closure: Closure!
    
    func callBack(closure: Closure!) {
        self.closure = closure
    }
}
