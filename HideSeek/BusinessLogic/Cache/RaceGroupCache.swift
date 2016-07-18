//
//  RaceGroupCache.swift
//  HideSeek
//
//  Created by apple on 7/4/16.
//  Copyright © 2016 mj. All rights reserved.
//

class RaceGroupCache : BaseCache<RaceGroup> {
    static let instance = RaceGroupCache()
    var raceGroupTableManager: RaceGroupTableManager!
    var version: Int64 = 0
    
    var raceGrouplist: NSArray {
        if(super.cacheList.count > 0) {
            return super.cacheList
        }
        
        return raceGroupTableManager.searchRaceGroup()
    }
    
    private override init() {
        super.init()
        raceGroupTableManager = RaceGroupTableManager.instance
    }
    
    func getMoreRaceGroup(count: Int) -> NSArray {
        let raceGroupList = raceGroupTableManager.getMoreRaceGroup(count, version: version)
        
        return raceGroupList
    }
    
    func setRaceGroup(raceGroupInfo: NSDictionary!) {
        saveRaceGroup(raceGroupInfo)
        
        cacheList = raceGroupTableManager.searchRaceGroup()
        version = raceGroupTableManager.version
    }
    
    func saveRaceGroup(result: NSDictionary!) {
        let list = NSMutableArray()
        let temp_version = result["version"] as? NSString
        var version: Int64
        if(temp_version == nil) {
            version = raceGroupTableManager.version
        } else {
            version = (temp_version?.longLongValue)!
        }
        let recordMinId = (result["record_min_id"] as! NSString).longLongValue
        let raceGroupArray = result["race_group"] as! NSArray
        
        for raceGroup in raceGroupArray {
            let raceGroupInfo = raceGroup as! NSDictionary
            let recordIdStr = raceGroupInfo["pk_id"] as! NSString
            list.addObject(RaceGroup(recordId: recordIdStr.longLongValue,
                nickname: raceGroupInfo["nickname"] as! String,
                photoUrl: raceGroupInfo["photo_url"] as! String,
                recordItem: RecordItem(
                    recordId: recordIdStr.longLongValue,
                    time: raceGroupInfo["time"] as! String,
                    goalType: Goal.GoalTypeEnum(rawValue: (raceGroupInfo["goal_type"] as! NSString).integerValue)!,
                    score: (raceGroupInfo["score"] as! NSString).integerValue,
                    scoreSum: (raceGroupInfo["score_sum"] as! NSString).integerValue,
                    version: (raceGroupInfo["version"] as! NSString).longLongValue)))
        }
        
        raceGroupTableManager.updateRaceGroup(recordMinId, version: version, raceGroupList: list)
    }
    
    func addRaceGroup(result: NSDictionary!) {
        saveRaceGroup(result)
        
        cacheList.arrayByAddingObjectsFromArray(getMoreRaceGroup(10) as [AnyObject])
    }
}
