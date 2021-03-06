//
//  MatchRoleController.swift
//  HideSeek
//
//  Created by apple on 8/1/16.
//  Copyright © 2016 mj. All rights reserved.
//

import UIKit

class MatchRoleController: UIViewController {

    @IBOutlet weak var roleNameLabel: UILabel!
    @IBOutlet weak var roleImageView: UIImageView!
    @IBOutlet weak var registerBtn: UIButton!
    var animation: CAKeyframeAnimation!
    var imageArray: Array<CGImage> = Array<CGImage>()
    
    @IBAction func registerBtnClicked(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        let imageNameArray = AnimationImageFactory.getRoleArray()
        
        for imageName in imageNameArray {
            let filePath = NSBundle.mainBundle().pathForResource(imageName as? String, ofType: ".png")
            imageArray.append((UIImage(contentsOfFile: filePath!)?.CGImage)!)
        }
        
        animation = CAKeyframeAnimation(keyPath: "contents")
        animation.delegate = self
        animation.values = imageArray
        animation.duration = 0.5
        animation.repeatCount = 10
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        roleImageView.layer.addAnimation(animation, forKey: "role")
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        
        super.viewWillDisappear(animated)
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        let image = imageArray[UserCache.instance.user.role.rawValue]
        roleImageView.image = UIImage(CGImage: image)
        roleNameLabel.text = UserCache.instance.user.roleName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView() {
        registerBtn.setBackgroundColor("#ffffff", selectedColorStr: "#f0f0f0", disabledColorStr: "#f0f0f0")
        registerBtn.layer.cornerRadius = 5
        registerBtn.layer.masksToBounds = true
    }

}
