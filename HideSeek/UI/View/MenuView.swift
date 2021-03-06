//
//  MenuView.swift
//  HideSeek
//
//  Created by apple on 7/24/16.
//  Copyright © 2016 mj. All rights reserved.
//

import UIKit

class MenuView: UIControl {
    var touchDownDelegate: TouchDownDelegate!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.addTarget(self, action: #selector(MenuView.touchDown), forControlEvents: UIControlEvents.TouchDown)
        self.addTarget(self, action: #selector(MenuView.touchCancel), forControlEvents: UIControlEvents.TouchCancel)
        self.addTarget(self, action: #selector(MenuView.touchCancel), forControlEvents: UIControlEvents.TouchUpInside)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(MenuView.gestureTouchDown))
        self.addGestureRecognizer(gesture)
    }
    
    func gestureTouchDown() {
        touchDownDelegate?.touchDown(self.tag)
    }
    
    func touchDown() {
        self.backgroundColor = BaseInfoUtil.stringToRGB("#f1f0f0")
    }
    
    func touchCancel() {
        self.backgroundColor = UIColor.whiteColor()
    }
}
