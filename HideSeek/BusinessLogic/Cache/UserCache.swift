//
//  UserCache.swift
//  HideSeek
//
//  Created by apple on 6/28/16.
//  Copyright © 2016 mj. All rights reserved.
//

class UserCache {
    static let instance = UserCache()
    var ifNeedRefresh: Bool = false
    
    private var _user: User! = nil
    var user: User! {
        get{
            if(_user != nil) {
                return _user
            }
            
            let tempUserInfo = NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultParam.USER_INFO) as? NSDictionary
            
            if(tempUserInfo == nil) {
                return nil
            }
            
            return from(tempUserInfo!)
        }
        set {
            _user = newValue
        }
    }
    
    func setUser(userInfo: NSDictionary) {
        user = from(userInfo)
        
        NewFriendTableManager.instance.refreshTable(user.pkId)
        
        if(userInfo.objectForKey("friend_requests") != nil) {
            let friendRequests = userInfo["friend_requests"] as! NSArray
            
            NewFriendCache.instance.setFriends(friendRequests)
        }
        
        if(user.pkId > 0) {
            NSUserDefaults.standardUserDefaults().setObject(userInfo["session_id"], forKey: UserDefaultParam.SESSION_TOKEN)
            let tempUserInfo = BaseInfoUtil.removeNullFromDictionary(userInfo)
            NSUserDefaults.standardUserDefaults().setObject(tempUserInfo, forKey: UserDefaultParam.USER_INFO)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func from(userInfo: NSDictionary)-> User {
        let user = User (pkId: (userInfo["pk_id"] as! NSString).longLongValue,
                         phone: userInfo["phone"] as! String,
                         sessionId: userInfo["session_id"] as! String,
                         nickname: userInfo["nickname"] as! String,
                         registerDateStr: userInfo["register_date"] as! String,
                         record: BaseInfoUtil.getIntegerFromAnyObject(userInfo["record"]!),
                         role: User.RoleEnum(rawValue: BaseInfoUtil.getIntegerFromAnyObject(userInfo["role"]))!,
                         version: (userInfo["version"] as! NSString).longLongValue,
                         pinyin: PinYinUtil.converterToPinyin(userInfo["nickname"] as! String),
                         bombNum: BaseInfoUtil.getIntegerFromAnyObject(userInfo["bomb_num"]),
                         hasGuide: BaseInfoUtil.getIntegerFromAnyObject(userInfo["has_guide"]) == 1,
                         friendNum: BaseInfoUtil.getIntegerFromAnyObject(userInfo["friend_num"]),
                         sex: User.SexEnum(rawValue: BaseInfoUtil.getIntegerFromAnyObject(userInfo["sex"]))!,
                         photoUrl: userInfo["photo_url"] as? NSString,
                         smallPhotoUrl: userInfo["small_photo_url"] as? NSString,
                         region: userInfo["region"] as? NSString,
                         defaultArea: userInfo["default_area"] as? NSString,
                         defaultAddress: userInfo["default_address"] as? NSString)
        
        return user
    }
    
    func ifLogin()-> Bool {
        let userDefault = NSUserDefaults.standardUserDefaults()
        let sessionToken = userDefault.objectForKey(UserDefaultParam.SESSION_TOKEN) as? NSString
        
        return sessionToken != nil
    }
}
