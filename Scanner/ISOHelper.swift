//
//  ISOHelper.swift
//  Scanner
//
//  Created by isBSO on 10/6/16.
//  Copyright © 2016 S. All rights reserved.
//

import UIKit
import CoreMedia

class ISOHelper: NSObject {
     static let sharedInstance = ISOHelper()
    var currentTime: Float?
    var currentISO: Float?
      var currentValueTimePresent :Bool = false
    var currentValueISOPResent :Bool = false
    
        var defaultValuesPResent :Bool = false
    
    
    var defaultTime: CMTime?
    var defaultISO: Float?

}
