//
//  ViewController.swift
//  HideSeek
//
//  Created by apple on 6/14/16.
//  Copyright © 2016 mj. All rights reserved.
//

import UIKit

class ViewController: UITabBarController {
    
    @IBOutlet weak var uiTabBar: UITabBar!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiTabBar.tintColor = BaseInfoUtil.stringToRGB("ffcc00")
        
        for item in uiTabBar.items! {
            item.image = item.image?.imageWithRenderingMode(.AlwaysOriginal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
