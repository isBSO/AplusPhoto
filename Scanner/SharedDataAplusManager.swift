//
//  SharedDataAplusManager.swift
//  Scanner
//
//  Created by isBSO on 9/25/16.
//  Copyright © 2016 S. All rights reserved.
//

import UIKit

class SharedDataAplusManager: NSObject {
     static let sharedInstance = SharedDataAplusManager()
    var times:Int = 5
    var interval:Int = 3
    
   class func  get() -> (times:Int, interval:Int) {
    
        if   let sharedUserDefaults  = UserDefaults(suiteName: "group.com.rajthala.camera") {
            if sharedUserDefaults.value(forKey: "times") != nil{
                self.sharedInstance.times = sharedUserDefaults.value(forKey: "times") as! Int

            }
            if sharedUserDefaults.value(forKey: "interval") != nil{
                self.sharedInstance.interval = sharedUserDefaults.value(forKey: "interval") as! Int

                
            }
            
                  }
   
        return (times:self.sharedInstance.times , interval : self.sharedInstance.interval)
    }
    class func save(times:Int , interval:Int)
    {
        
//        NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.example.app"];
        
        
        let sharedUserDefaults = UserDefaults(suiteName: "group.com.rajthala.camera")
        sharedUserDefaults?.set(times, forKey: "times")
        sharedUserDefaults?.set(interval, forKey: "interval")
        sharedUserDefaults?.synchronize()
        
    }
    
    
    
    
    

}

