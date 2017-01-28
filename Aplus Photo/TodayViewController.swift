//
//  TodayViewController.swift
//  Aplus Photo
//
//  Created by isBSO on 9/25/16.
//  Copyright © 2016 S. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var interValLabel: UILabel!
    @IBOutlet weak var timesLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
       
        
   let (times, interval ) =     SharedDataAplusManager.get()
        interValLabel.text = String(interval) + " seconds"
        timesLabel.text = String(times) + " times"
        
        interValLabel.layer.borderWidth = 1.0
        interValLabel.layer.borderColor = UIColor.white.cgColor
        
        
        timesLabel.layer.borderWidth = 1.0
        timesLabel.layer.borderColor = UIColor.white.cgColor
        
      
    
    }
    @IBAction func doTheAction(_ sender: AnyObject) {
//        NSURL *url = [NSURL URLWithString:@"floblog://"];
//        [self.extensionContext openURL:url completionHandler:nil];
        let url = NSURL(string: "aPlusPhoto://")
        self.extensionContext?.open(url as! URL, completionHandler: { (possible) in
            //
            if possible{
                //print("possible")
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
