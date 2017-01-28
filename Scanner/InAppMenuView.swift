//
//  InAppMenuView.swift
//  Scanner
//
//  Created by isBSO on 9/17/16.
//  Copyright © 2016 S. All rights reserved.
//

import UIKit
protocol InAppMenuViewDelegate: class {
      func startTakingPictures(interval:UInt64, times:UInt64 )
    func goPro(_ sender: AnyObject)
}

class InAppMenuView: UIView, UICollectionViewDelegate ,UICollectionViewDataSource{
    weak var delegate:InAppMenuViewDelegate?
    @IBOutlet weak var inappMenuLabel: UILabel!
    let interValOptions: NSMutableArray = [2, 3]
    let timesOption: NSMutableArray = [2,5, ]
    
    var intervalSelectedValue:NSInteger = 3
    var timeSelectedValue :NSInteger = 5
    var intervalSelected: Bool = true
    static func instantiate()-> InAppMenuView
    {
        
     let nib =   UINib(nibName: "InAppMenuView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! InAppMenuView
     return nib

    }
    override func didMoveToSuperview() {
        self.collectionView.register(UINib.init(nibName: "TimerOptionsCell", bundle: nil), forCellWithReuseIdentifier: "TimerOptionsCell")
        self.collectionView.delegate = self
        setupInAppMenuLanel()
    }
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func startTaking(_ sender: AnyObject) {
        self.delegate?.startTakingPictures(interval: UInt64(intervalSelectedValue), times: UInt64(timeSelectedValue))
        SharedDataAplusManager.save(times: timeSelectedValue, interval: intervalSelectedValue)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimerOptionsCell", for: indexPath) as! TimerOptionsCell
               cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 5.0
        cell.layer.borderColor = UIColor.black.cgColor
                cell.backgroundColor = UIColor.lightGray
        if intervalSelected{
           
         let value =  interValOptions[indexPath.row]  as! NSInteger
            if value   == intervalSelectedValue{
                cell.backgroundColor = UIColor.green
            }
            
           
            
             cell.optL.text =   "\(value)"

        }
        else{
            let value =  timesOption[indexPath.row]  as! NSInteger
            if value   == timeSelectedValue{
                cell.backgroundColor = UIColor.green
            }
            cell.optL.text =   "\(value)"

            
            
        }
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 5.0
        cell.layer.borderColor = UIColor.black.cgColor
        return cell
    }
    func  collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if intervalSelected{
            return interValOptions.count
            
        }
        else{
            return timesOption.count
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if InAppPurchaseHelper.inAppPurchasePresent(){
            if intervalSelected{
                let value =  interValOptions[indexPath.row]  as! NSInteger
                intervalSelectedValue = value
                
            }
            else{
                let value =  timesOption[indexPath.row]  as! NSInteger
                timeSelectedValue = value
            }
        }
        else{
            //purchase not present
            if intervalSelected{
                let value =  interValOptions[indexPath.row]  as! NSInteger
                if value>3{
                    //purchase not made
                    promptForPurchase()
                }
                else{
                   intervalSelectedValue = value
                }
             
                
                
            }
            else{
                let value =  timesOption[indexPath.row]  as! NSInteger
                if value>5{
                    //purchase not made
                    promptForPurchase()
                }
                else{
                    timeSelectedValue = value
                }
              
                
              
            }
        }
 
            
    
        collectionView.reloadData()
    }
    func promptForPurchase()  {
        //print("need to show purchase options")
        self.delegate?.goPro(UIButton())
    }
    func setupInAppMenuLanel()  {
        if intervalSelected{
            inappMenuLabel.text = "seconds"
        }
        else{
            inappMenuLabel.text = "times"
        }
        
    }
    @IBAction func segmentControlChanged(_ sender: UISegmentedControl) {
        
        
        if sender.selectedSegmentIndex == 0 {
            intervalSelected = true
            
        }
        else{
            intervalSelected = false
            
        }
        setupInAppMenuLanel()
        collectionView.reloadData()
     
    }

}
