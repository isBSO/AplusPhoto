//
//  ISOOptionsView.swift
//  Scanner
//
//  Created by isBSO on 9/25/16.
//  Copyright © 2016 S. All rights reserved.
//

import UIKit
import AVFoundation
protocol ISOOPtionsDelegate: class {
    
    func updatethings(timeSend:CGFloat, iSO:CGFloat , close:Bool)
    func reset()
    
   
}

class ISOOptionsView: UIView , UICollectionViewDelegate ,UICollectionViewDataSource{
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate:ISOOPtionsDelegate?
    var ISOOptions: NSArray?
    var device : AVCaptureDevice?
    var currentValueTime : CGFloat?
    var currentValueISO : CGFloat?
    
    @IBOutlet weak var sliderTime: UISlider!
    @IBOutlet weak var sliderValueLabel: UILabel!
    @IBOutlet weak var isoValueLabel: UILabel!
    @IBOutlet weak var iSOSlider: UISlider!

    static func instantiate(device:AVCaptureDevice?)-> ISOOptionsView
    {
        
        let nib =   UINib(nibName: "ISOOptionsView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ISOOptionsView
       nib.device = device
        
        return nib
        
    }
    override func didMoveToSuperview() {
    
        self.collectionView.delegate = nil
        sliderTime.minimumValue = Float(CMTimeGetSeconds( (device?.activeFormat.minExposureDuration)!))
       
          sliderTime.maximumValue = Float(CMTimeGetSeconds( (device?.activeFormat.maxExposureDuration)!))
        
         currentValueTime  = CGFloat(CMTimeGetSeconds( (device?.exposureDuration)!))
        
        
        
        sliderTime.value = Float(CGFloat(currentValueTime!))
     
        
        
        
        currentValueISO  = CGFloat((self.device?.iso)!);
        
        
        //ISO settings
        iSOSlider.value = Float(currentValueISO!)
        
        iSOSlider.minimumValue =  (device?.activeFormat.minISO)!
        iSOSlider.maximumValue =  (device?.activeFormat.maxISO)!
        
        if ISOHelper.sharedInstance.defaultValuesPResent{
            
           
         
            
            
        }
        else{
            ISOHelper.sharedInstance.defaultValuesPResent = true
            ISOHelper.sharedInstance.defaultISO = device?.iso
            ISOHelper.sharedInstance.defaultTime =  device?.exposureDuration
            
        }
        if ISOHelper.sharedInstance.currentValueISOPResent{
            iSOSlider.value = ISOHelper.sharedInstance.currentISO!
            
        }
        if ISOHelper.sharedInstance.currentValueTimePresent{
            
          
           
            
            
            
            sliderTime.value = ISOHelper.sharedInstance.currentTime!
            
        }
       
       
      
    }
  
    @IBAction func isoValueChanged(_ sender: UISlider) {
        let currentValue = CGFloat(sender.value)
        //print(currentValue)
        
        isoValueLabel.text = String(format: "%.0f ISO", currentValue)

         currentValueTime = CGFloat(sliderTime.value)
         currentValueISO = CGFloat(iSOSlider.value)
      
    
        
        self.delegate?.updatethings(timeSend: currentValueTime!, iSO: currentValueISO! , close:false)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentValue = CGFloat(sender.value)
        //print(currentValue)
        let currentValueTime = CGFloat(sliderTime.value)
         currentValueISO = CGFloat(iSOSlider.value)
        
        ISOHelper.sharedInstance.currentTime = iSOSlider.value
        ISOHelper.sharedInstance.currentValueTimePresent = true
        
        self.delegate?.updatethings(timeSend: currentValueTime, iSO: currentValueISO! , close:false)
        sliderValueLabel.text = String(format: "%.8f seconds", currentValue)
    }
    @IBAction func saveTheISOANDTIME(_ sender: AnyObject) {
        let currentValueTime = CGFloat(sliderTime.value)
          let currentValueISO = CGFloat(iSOSlider.value)
        
        self.delegate?.updatethings(timeSend: currentValueTime, iSO: currentValueISO , close:true)
    }
   
 
    
    @IBAction func reset(_ sender: AnyObject) {
        self.delegate?.reset()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimerOptionsCell", for: indexPath) as! TimerOptionsCell
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 5.0
        cell.layer.borderColor = UIColor.black.cgColor
        cell.backgroundColor = UIColor.lightGray
      
            
            let value =  ISOOptions?[indexPath.row]  as! NSInteger
        
                cell.backgroundColor = UIColor.green
        
            
            
            
            cell.optL.text =   "\(value)"
       
            
            
            
        
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 5.0
        cell.layer.borderColor = UIColor.black.cgColor
        return cell
    }
    func  collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     return ISOOptions!.count
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
        ////print("need to show purchase options")
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
