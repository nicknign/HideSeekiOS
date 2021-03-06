//
//  CustomRequestManager.swift
//  HideSeek
//
//  Created by apple on 7/4/16.
//  Copyright © 2016 mj. All rights reserved.
//
import AFNetworking

class CustomRequestManager: AFHTTPRequestOperationManager {
    var ifLock: Bool = false
    
    func POST(URLString: String,
              paramDict: NSMutableDictionary,
              success: ((AFHTTPRequestOperation, AnyObject) -> Void)?,
              failure: ((AFHTTPRequestOperation?, NSError) -> Void)?) -> AFHTTPRequestOperation? {
        if ifLock {
            return nil
        }
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        let sessionToken = userDefault.objectForKey(UserDefaultParam.SESSION_TOKEN) as? String
        
        paramDict["session_id"] = sessionToken
        paramDict["app_version"] = BaseInfoUtil.getAppVersion()
        
        return super.POST(URLString, parameters: paramDict, success: success, failure: failure)
    }
    
    func POST(URLString: String, paramDict: NSMutableDictionary, constructingBodyWithBlock block: ((AFMultipartFormData) -> Void)?, success: ((AFHTTPRequestOperation, AnyObject) -> Void)?, failure: ((AFHTTPRequestOperation?, NSError) -> Void)?) -> AFHTTPRequestOperation? {
        if ifLock {
            return nil
        }

        let userDefault = NSUserDefaults.standardUserDefaults()
        let sessionToken = userDefault.objectForKey(UserDefaultParam.SESSION_TOKEN) as? String
        paramDict["session_id"] = sessionToken
        
        return super.POST(URLString, parameters: paramDict, constructingBodyWithBlock: block, success: success, failure: failure)
    }
}
