//
//  RecordCache.swift
//  HideSeek
//
//  Created by apple on 7/8/16.
//  Copyright © 2016 mj. All rights reserved.
//

class RecordCache : BaseCache<Record> {
    static let instance = RecordCache()
    var recordTableManager: RecordTableManager!
    let dateTimeFormatter = NSDateFormatter()
    let timeFormatter = NSDateFormatter()
    let dateFormatter = NSDateFormatter()
    var version: Int64 = 0
    private var _scoreSum: Int = 0
    var scoreSum: Int {
        get{
            return recordTableManager.scoreSumValue
        }
    }
    
    var recordList: NSMutableArray {
        if(super.cacheList.count == 0) {
            super.cacheList = recordTableManager.searchRecords()
        }
        
        return super.cacheList
    }
    
    private override init() {
        super.init()
        recordTableManager = RecordTableManager.instance
        dateTimeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        timeFormatter.dateFormat = "HH:mm"
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    func setRecords(recordInfo: NSDictionary!) {
        saveRecords(recordInfo)
        
        cacheList = recordTableManager.searchRecords()
        version = recordTableManager.version
    }
    
    func addRecords(result: NSDictionary!) {
        saveRecords(result)
        
        getMoreRecord(10, hasLoaded: true)
    }
    
    func saveRecords(result: NSDictionary!) {
        let list = NSMutableArray()
        let tempVersion = result["version"] as? NSString
        var version: Int64
        if(tempVersion == nil) {
            version = recordTableManager.version
        } else {
            version = (tempVersion?.longLongValue)!
        }
        let recordMinId = (result["record_min_id"] as! NSString).longLongValue
        
        if result["score_sum"] != nil {
            _scoreSum = BaseInfoUtil.getIntegerFromAnyObject(result["score_sum"])
            UserCache.instance.user.record = _scoreSum
        }
        
        let recordArray = result["scores"] as! NSArray
        
        for record in recordArray{
            let recordInfo = record as! NSDictionary
            let time = recordInfo["time"] as! String
            let date = dateTimeFormatter.dateFromString(time)
            
            list.addObject(Record(date: dateFormatter.stringFromDate(date!),
                recordId: (recordInfo["pk_id"] as! NSString).longLongValue,
                time: timeFormatter.stringFromDate(date!),
                goalType: Goal.GoalTypeEnum(rawValue: BaseInfoUtil.getIntegerFromAnyObject(recordInfo["goal_type"]))!,
                score: BaseInfoUtil.getIntegerFromAnyObject(recordInfo["score"]),
                scoreSum: BaseInfoUtil.getIntegerFromAnyObject(recordInfo["score_sum"]),
                version: (recordInfo["version"] as! NSString).longLongValue,
                showTypeName: recordInfo["show_type_name"] as? String))
        }
        
        recordTableManager.updateRecords(_scoreSum, recordMinId: recordMinId, version: version, recordList: list)
    }
    
    func getMoreRecord(count: Int, hasLoaded: Bool) -> Bool{
        let recordList = recordTableManager.getMoreRecords(count, version: version, hasLoaded: hasLoaded)
        
        self.cacheList.addObjectsFromArray(recordList as [AnyObject])
        
        return recordList.count > 0
    }
}
