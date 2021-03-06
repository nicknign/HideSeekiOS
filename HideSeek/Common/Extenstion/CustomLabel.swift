//
//  CustomNSString.swift
//  HideSeek
//
//  Created by apple on 7/4/16.
//  Copyright © 2016 mj. All rights reserved.
//

extension UILabel {
    func modifyHeight() {
        let option = NSStringDrawingOptions.UsesLineFragmentOrigin
        let attributes = NSDictionary(object: self.font, forKey: NSFontAttributeName)
        let size = CGSizeMake(self.frame.width, CGFloat(MAXFLOAT))
        let stringRect = self.text!.boundingRectWithSize(size,
                                                         options: option,
                                                         attributes: attributes as? [String : AnyObject],
                                                         context: nil)
        self.layer.frame = CGRectMake(self.frame.minX, self.frame.minY, stringRect.size.width, stringRect.size.height)
        
    }
    
    func modifyWidth() {
        let option = NSStringDrawingOptions.UsesLineFragmentOrigin
        let attributes = NSDictionary(object: self.font, forKey: NSFontAttributeName)
        let size = CGSizeMake(CGFloat(MAXFLOAT), self.frame.height)
        let stringRect = self.text!.boundingRectWithSize(size,
                                                         options: option,
                                                         attributes: attributes as? [String : AnyObject],
                                                         context: nil)
        self.layer.frame = CGRectMake(self.frame.minX, self.frame.minY, stringRect.size.width, stringRect.size.height)
    }
}
