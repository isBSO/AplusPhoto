//
//  InAppPurchaseHelper.swift
//  Scanner
//
//  Created by isBSO on 9/18/16.
//  Copyright © 2016 S. All rights reserved.
//

import UIKit

class InAppPurchaseHelper: NSObject {
    class func inAppPurchasePresent()->Bool{
        return false;
    }

}


import Foundation

public struct AplusProducts {
    
    public static let AplusPro = "com.rajthala.photoshoot.pro"
    
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [AplusProducts.AplusPro]
    
    public static let store = IAPHelper(productIds: AplusProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
