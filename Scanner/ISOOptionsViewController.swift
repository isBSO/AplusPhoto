//
//  ISOOptionsViewController.swift
//  Scanner
//
//  Created by isBSO on 9/25/16.
//  Copyright © 2016 S. All rights reserved.
//

import UIKit

class ISOOptionsViewController: UIViewController, UICollectionViewDelegate ,UICollectionViewDataSource{
    @IBOutlet weak var collectionView: UICollectionView!
    
    let ISOOptions: NSMutableArray = [2, 3,5,10,15,20,25,30,60]
    
    //MARK:Instantiate
    static func instantiate()-> ISOOptionsViewController
    {
        return UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ISOOptionsViewController") as! ISOOptionsViewController
    }
    override func viewDidLoad() {
        self.title = "Select ISO Settings" 
        self.collectionView.register(UINib.init(nibName: "TimerOptionsCell", bundle: nil), forCellWithReuseIdentifier: "TimerOptionsCell")
        self.collectionView.delegate = self
        let dismiss = UIBarButtonItem(title: "Dismiss",
                                      style: .plain,
                                      target: self,
                                      action: #selector(ISOOptionsViewController.dismissTapped(_:)))
        navigationItem.leftBarButtonItem = dismiss
    }
    func dismissTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)    }

        
    
    
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimerOptionsCell", for: indexPath) as! TimerOptionsCell
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 5.0
        cell.layer.borderColor = UIColor.black.cgColor
        cell.backgroundColor = UIColor.lightGray
        
        
        let value =  ISOOptions[indexPath.row]  as! NSInteger
        
        cell.backgroundColor = UIColor.green
        
        
        
        
        cell.optL.text =   "\(value)"
        
        
        
        
        
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 5.0
        cell.layer.borderColor = UIColor.black.cgColor
        return cell
    }
    func  collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ISOOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //        if InAppPurchaseHelper.inAppPurchasePresent(){
        //            if intervalSelected{
        //                let value =  interValOptions[indexPath.row]  as! NSInteger
        //                intervalSelectedValue = value
        //
        //            }
        //            else{
        //                let value =  timesOption[indexPath.row]  as! NSInteger
        //                timeSelectedValue = value
        //            }
        //        }
        //        else{
        //            //purchase not present
        //            if intervalSelected{
        //                let value =  interValOptions[indexPath.row]  as! NSInteger
        //                if value>3{
        //                    //purchase not made
        //                    promptForPurchase()
        //                }
        //                else{
        //                    intervalSelectedValue = value
        //                }
        //
        //
        //
        //            }
        //            else{
        //                let value =  timesOption[indexPath.row]  as! NSInteger
        //                if value>3{
        //                    //purchase not made
        //                    promptForPurchase()
        //                }
        //                else{
        //                    timeSelectedValue = value
        //                }
        //
        //
        //
        //            }
        //        }
        //
        
        
        collectionView.reloadData()
    }
    func promptForPurchase()  {
        //print("need to show purchase options")
        //        self.delegate?.goPro(UIButton())
}



/*
 // Only override draw() if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 override func draw(_ rect: CGRect) {
 // Drawing code
 }
 */
}
