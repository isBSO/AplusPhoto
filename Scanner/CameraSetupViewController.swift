//
//  CameraSetupViewController.swift
//  Scanner
//
//  Created by isBSO on 9/10/16.
//  Copyright © 2016 S. All rights reserved.
//

import UIKit

class CameraSetupViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
    var permissionCamera :Bool = false
    var permissionPhotos :Bool = false
 
    @IBOutlet weak var collectionView: UICollectionView!
    static func instantiate()-> CameraSetupViewController
  {
    return UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CameraSetupViewController") as! CameraSetupViewController
    }

    @IBOutlet weak var blurViewSetup: UIView!
    @IBOutlet weak var sunsetView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = sunsetView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        blurEffectView.alpha = 0.5
        sunsetView.addSubview(blurEffectView)
        
     CameraViewController.canShowCameraView(completion: { (success) in
        
        
        //
        if success{
            self.permissionCamera = true
        }
        self.reloadViewInMainQueue()

        CameraViewController.checkPhotoLibraryPermission(completion: { (photoPermissionGrandted) in
            if photoPermissionGrandted{
                self.permissionPhotos = true
               
            }
            self.reloadViewInMainQueue()
            if self.permissionPhotos&&self.permissionCamera{

                let cameraVC = CameraViewController.instantiate()
              
                DispatchQueue.main.async { [unowned self] in
                    self.navigationController?.viewControllers = [cameraVC]

                }
               
            }
            
            
        })
    })
    }
    
    func reloadViewInMainQueue()  {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            
        }
        
    }
    
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SetupCollectionViewCell", for: indexPath) as! SetupCollectionViewCell
        cell.backgroundColor = UIColor.white
        
        if indexPath.row == 0 {
            if self.permissionCamera{
                                    cell.allowActionButton.isEnabled = false
                                    cell.allowActionButton.setTitle("", for: UIControlState())
                                    cell.infoLabel.text = "App has permission to take pictures"
                cell.backgroundColor = UIColor.green
                                }
                                else{
                                    cell.allowActionButton.setTitle("Settings", for: UIControlState())
                                    cell.allowActionButton.isEnabled = false
                 cell.infoLabel.text = "App  does not has permission to take pictures"
                                }
                                cell.iconImageView.image = UIImage.init(named: "cameraIcon")
        }
        else{
            if self.permissionPhotos{
                 cell.backgroundColor = UIColor.green
                cell.allowActionButton.isEnabled = false
                cell.allowActionButton.setTitle("", for: UIControlState())
                cell.infoLabel.text = "App has permission to take pictures"
            }
            else{
                 cell.infoLabel.text = "App does not have permission to save pictures"
                cell.allowActionButton.setTitle("Settings", for: UIControlState())
                cell.allowActionButton.isEnabled = false
            }
            cell.iconImageView.image = UIImage.init(named: "photo")
        }

        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 5.0
        cell.layer.borderColor = UIColor.black.cgColor
//        cell.backgroundColor = UIColor.red()
        return cell
    }
    func  collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let settingsURL = NSURL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.openURL(settingsURL as URL)
            
        
        }
    }

}
