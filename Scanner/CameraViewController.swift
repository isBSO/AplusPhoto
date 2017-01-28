//
//  ViewController.swift
//  Scanner
//
//  Created by isBSO on 9/9/16.
//  Copyright © 2016 S. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
  
class CameraViewController : UIViewController ,UIImagePickerControllerDelegate,InAppMenuViewDelegate, UIGestureRecognizerDelegate, PHPhotoLibraryChangeObserver,AVCapturePhotoCaptureDelegate,ISOOPtionsDelegate{
    
    @IBOutlet weak var iSOOptionsViewLocation: UIView!
    
    @IBOutlet weak var thirdStack: UIView!
    @IBOutlet weak var containerMenu: UIView!
    @IBOutlet weak var flashButtonTop: NSLayoutConstraint!
    var menuView:InAppMenuView?
    var  iSOOptions: ISOOptionsView?
    @IBOutlet weak var lastPhoto: UIImageView!
    @IBOutlet weak var layer: UIView!
      let screenWidth = UIScreen.main.bounds.size.width
    var flashMode :AVCaptureFlashMode = AVCaptureFlashMode.auto
    
    @IBOutlet weak var takingPPicture: UIView!
    
    @IBOutlet weak var menuButton: UIButton!
    let captureSession = AVCaptureSession()
     var previewLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer()
 
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    var timer:Timer?
    var times: UInt64?
    var isShowingMenu:Bool = false
     var canStop:Bool = false
     var isoSettingsOpen:Bool = false
    
    
    @IBOutlet weak var flashButton: UIButton!
    var settings = AVCapturePhotoSettings()
    
    let cameraOutput = AVCapturePhotoOutput()
    //MARK: view LifeCycle
    
    var images:NSMutableArray! // <-- Array to hold the fetched images
    var totalImageCountNeeded
    :Int! // <-- The number of images to fetch
    func showbordersAfterTakingPicture(show:Bool)  {
        
        if show{
          
            takingPPicture?.layer.borderWidth = 0.5
            takingPPicture?.layer.cornerRadius = 5.0
            takingPPicture?.layer.borderColor = UIColor.white.cgColor
        }
        else{
            self.takingPPicture?.layer.borderWidth = 0.0
            self.takingPPicture?.layer.cornerRadius = 0.0
            self.takingPPicture?.layer.borderColor = UIColor.white.cgColor
 
        }
      
      }
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        fetchPhotos()
        
    }
    
    @IBAction func flash(_ sender: UIButton) {
   
        switch self.flashMode {
        case AVCaptureFlashMode.auto:
            self.flashMode = AVCaptureFlashMode.on
          
            self.flashButton.setImage(UIImage.init(named: "flashOn"), for:  UIControlState.normal)
        case AVCaptureFlashMode.on:
            self.flashMode = AVCaptureFlashMode.off
                 self.flashButton.setImage(UIImage.init(named: "flashOff"), for:  UIControlState.normal)
        case AVCaptureFlashMode.off:
            self.flashMode = AVCaptureFlashMode.auto
   self.flashButton.setImage(UIImage.init(named: "flashAuto"), for:  UIControlState.normal)            
       
        }
        self.settings.flashMode = self.flashMode
      
    }
    
    
    func fetchPhotos () {
        images = NSMutableArray()
        totalImageCountNeeded = 1
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
//            
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            // your function here
            self.fetchPhotoAtIndexFromEnd(index: 0)
//        }
        
    }
//    func fixOrientation(img:UIImage) -> UIImage {
//        
////        if (img.imageOrientation == UIImageOrientation.up) {
////            return img;
////        }
////        
////        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
////        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
////        img.draw(in: rect)
////        
////        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
////        UIGraphicsEndImageContext();
////        return normalizedImage;
//        
//    }
    func fetchPhotoAtIndexFromEnd(index:Int) {
        let imgManager = PHImageManager.default()
        
        // Note that if the request is not set to synchronous
        // the requestImageForAsset will return both the image
        // and thumbnail; by setting synchronous to true it
        // will return just the thumbnail
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        
        // Sort the images by creation date
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        
        
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
            
            // If the fetch result isn't empty,
            // proceed with the image request
            if fetchResult.count > 0 {
                // Perform the image request
                imgManager.requestImage(for: fetchResult.object(at: fetchResult.count - 1 - index) as PHAsset, targetSize: view.frame.size, contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: { (image, _) in
                    
                    // Add the returned image to your array
                    self.images.add(image)
                  
                    // If you haven't already reached the first
                    // index of the fetch result and if you haven't
                    // already stored all of the images you need,
                    // perform the fetch request again with an
                    // incremented index
                    if index + 1 < fetchResult.count && self.images.count < self.totalImageCountNeeded {
                        self.fetchPhotoAtIndexFromEnd(index: index + 1)
                    } else {
                        // Else you have completed creating your array
                        ////print("Completed array: \(self.images)")
                    }
                })
            }
        
      if self.images.count>0 {
        let image = self.images[0] as? UIImage
              // self.lastPhoto.image = self.lastPhoto.crop
        
        self.lastPhoto.image = self.lastPhoto.cropToBounds(image!, width: Double(44), height: Double(44))

      }
     
    
    }

    //MARK:Instantiate
    static func instantiate()-> CameraViewController
    {
        return UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timer?.invalidate()
    }
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        let gridAsset = AssetGridViewController.instantiate()
        self.navigationController?.pushViewController(gridAsset, animated: true)
    }
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
         containerMenu.alpha = 0
          takingPPicture.backgroundColor = UIColor.clear
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CameraViewController.handleTap))
        tap.delegate = self
        lastPhoto.addGestureRecognizer(tap)
        
        PHPhotoLibrary.shared().register(self)
        

      NotificationCenter.default.addObserver(self, selector: #selector(CameraViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        let devices = AVCaptureDevice.devices()
        
        // Loop through all the capture devices on this phone
        for device in devices! {
            // Make sure this particular device supports video
            if ((device as AnyObject).hasMediaType(AVMediaTypeVideo)) {
                // Finally check the position and confirm we've got the back camera
                if((device as AnyObject).position == AVCaptureDevicePosition.back) {
                    captureDevice = device as? AVCaptureDevice
                    if captureDevice != nil {
                        ////print("Capture device found")
                        beginSession()
                    }
                }
            }
        }
        
        
    }
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    //MARK: Handle rotated
    func rotated()
    {
        
        if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation))
        {
            ////print("landscape")
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation))
        {
            ////print("Portrait")
        }
        UIView.animate(withDuration: 0.5) { 
//           self.previewLayer.frame = self.view.layer.frame
      //      self.previewLayer.frame=self.view.bounds;
            if (self.previewLayer.connection) != nil  {
                let currentDevice: UIDevice = UIDevice.current
                let orientation: UIDeviceOrientation = currentDevice.orientation
                
//                let previewLayerConnection : AVCaptureConnection = connection
//               return
                let previewLayerConnection :AVCaptureConnection = self.cameraOutput.connection(withMediaType: AVMediaTypeVideo)
                if (previewLayerConnection.isVideoOrientationSupported)
                {
                    switch (orientation)
                    {
                    case .portrait:
                        
                        previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.portrait
                      //    self.previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.portrait
                        self.flashButtonTop.constant = 20
                        break
                    case .landscapeRight:
                        previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
                      //  self.previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
                          self.flashButtonTop.constant = 20
                        break
                    case .landscapeLeft:
                        previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.landscapeRight
                     //      self.previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.landscapeRight
                          self.flashButtonTop.constant = 20
                        break
                    case .portraitUpsideDown:
                        previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.portraitUpsideDown
                    //    self.previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.portraitUpsideDown
                          self.flashButtonTop.constant = 20
                        break
                        
                        
                    default:
                        previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.portrait
                     //   self.previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.portrait
                        break
                    }
                }
//                  self.iSOOptions?.frame = self.iSOOptionsViewLocation.frame
        }
        }

        
    }
    func rotateGuys()  {
        
    }
    override func viewWillAppear(_ animated: Bool) {
   self.navigationController?.setNavigationBarHidden(true, animated: true)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        fetchPhotos()
          }
    func appMovedToBackground() {
        ////print("App moved to background!")
        self.timer?.invalidate()
    }
   override func viewDidAppear(_ animated: Bool) {
    self.title = ""
    
    CameraViewController.canShowCameraView { (canShow) in
        if !canShow{
            ////print("Cannot show camera in View did load")
            // something happened so cannot show the camera
            let cameraSetupVC = CameraSetupViewController.instantiate()
            //            self.view.addSubview(cameraSetupVC.view)
            
            self.present(cameraSetupVC, animated: true, completion: {
                
            })
            
        }
     
        
        
    }
    }
   
    
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
       
        
        if let sampleBuffer = photoSampleBuffer,
            let previewBuffer = previewPhotoSampleBuffer,
            let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            let imageCapture = UIImage(data: dataImage)!
            UIImageWriteToSavedPhotosAlbum((image: imageCapture), nil, nil, nil)
            self.lastPhoto.image = imageCapture
          
        } else {
            
        }
        
    }
    //MARK: Take a picture
    @IBAction func takepicture(_ sender: UIButton) {
        
        settings =  AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                             kCVPixelBufferWidthKey as String: 1600,
                             kCVPixelBufferHeightKey as String: 1600,
                             ]
        settings.previewPhotoFormat = previewFormat
        settings.flashMode = self.flashMode
        settings.isHighResolutionPhotoEnabled = true
        
         self.cameraOutput.isHighResolutionCaptureEnabled = true
       
        self.cameraOutput.capturePhoto(with: settings, delegate: self)
        return

        
    }
    func fixOrientationOfImage(image: UIImage) -> UIImage? {
        if image.imageOrientation == .up {
            return image
        }
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform = CGAffineTransform.identity
        
        switch image.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: image.size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: image.size.height)
            transform = transform.rotated(by: -CGFloat(M_PI_2))
        default:
            break
        }
        
        switch image.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: image.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        guard let context = CGContext(data: nil, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: image.cgImage!.bitsPerComponent, bytesPerRow: 0, space: image.cgImage!.colorSpace!, bitmapInfo: image.cgImage!.bitmapInfo.rawValue) else {
            return nil
        }
        
        context.concatenate(transform)
        
        switch image.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        default:
            image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        }
        
        // And now we just create a new UIImage from the drawing context
        guard let CGImage = context.makeImage() else {
            return nil
        }
        
        return UIImage(cgImage: CGImage)
    }
    func focusTo(value : Float) {
//        if let device = captureDevice {
//            if(device.lockForConfiguration(nil)) {
//                device.setFocusModeLockedWithLensPosition(value, completionHandler: { (time) -> Void in
//                    //
//                })
//                device.unlockForConfiguration()
//            }
//        }
    }
    
  
     func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let anyTouch = touches.anyObject() as! UITouch
        let touchPercent = anyTouch.location(in: self.view).x / screenWidth
        focusTo(value: Float(touchPercent))
    }
    
     func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let anyTouch = touches.anyObject() as! UITouch
        let touchPercent = anyTouch.location(in: self.view).x / screenWidth
        focusTo(value: Float(touchPercent))
    }
    
    func configureDevice() {
        if let device = captureDevice {
            do{
              
              
                
                try device.lockForConfiguration()
               device.supportsAVCaptureSessionPreset(AVCaptureSessionPresetPhoto)
//                device.setExposureModeCustomWithDuration((device.activeFormat.maxExposureDuration), iso: 100, completionHandler: { (howmuch) in
//                    ////print("did set ios")
//                })
            }
            catch{
                
            }

            device.focusMode = .continuousAutoFocus
            device.unlockForConfiguration()
        }
        
    }
    //MARK: Capture Session start
    func beginSession() {
 
        self.configureDevice()
        // For the sake of discussion this is the camera
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
     
        do{
             let camera = try AVCaptureDeviceInput.init(device: device)
             captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
         

    
                captureSession.addInput(camera)
          
            captureSession.addOutput(cameraOutput)
                
            
        }
        catch{
            
        }
        
        

        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = self.view.layer.frame
        self.view.backgroundColor = UIColor.black
        self.layer.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    //MARK: Camera Permissions
  class  func canShowCameraView(completion: @escaping (_ result: Bool) -> Void)  {
        ////print(" show camera  CAlled *****")
  
        
        let authCameraBe = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch authCameraBe {
        case AVAuthorizationStatus.authorized:
           ////print("Cam Authorized")
           completion(true)
        case AVAuthorizationStatus.denied:
            ////print("Cam Authorized")
            completion(false)
        case AVAuthorizationStatus.restricted:
            ////print("Cam Authorized")
            completion(false)
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted :Bool) -> Void in
                if granted == true
                {
                        completion(true)
                    // User granted
                    // Already Authorized
                    ////print("Camera is just authorized")
                }
                else
                {
                    // User Rejected
                    // Already Authorized
                    ////print("Camera is not authorized")
                        completion(false)
                }
                
            })
        
        
            ////print("something")
        
        }
      
  
    
    }
    
     class func checkPhotoLibraryPermission(completion: @escaping (_ result: Bool) -> Void)  {
     
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized: 
         completion(true)
        case .denied, .restricted :
             completion(false)
        //handle denied status
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization() { (status) -> Void in
                switch status {
                case .authorized:
                    completion(true)
                // as above
                case .denied, .restricted: 
                    completion(false)
                // as above
                case .notDetermined: break
                    // won't happen but still
                }
            }
        }
    }
  
    @IBAction func openUpMenu(_ sender: UIButton) {
        self.containerMenu.backgroundColor = UIColor.clear
        containerMenu.alpha = 0
        if canStop{
            self.timer?.invalidate()
            canStop = false
//            menuButton.setTitle("Menu", for: UIControlState.normal)
            menuButton.setImage(UIImage.init(named: "menuStop"), for: UIControlState.normal)
            return;
        }
        if !isShowingMenu{
         menuView = InAppMenuView.instantiate()
        menuView?.frame = containerMenu.frame
            menuView?.frame = CGRect.init(x: 0, y: 0, width: (menuView?.frame.size.width)!, height:  (menuView?.frame.size.height)!)
            menuView?.delegate = self
               menuButton.setImage(UIImage.init(named: "menuOpen"), for: UIControlState.normal)
          self.closeISO()
            
        self.containerMenu.addSubview(menuView!)
            menuView?.layer.borderWidth = 0.5
            menuView?.layer.cornerRadius = 5.0
            menuView?.layer.borderColor = UIColor.black.cgColor
            containerMenu?.layer.borderWidth = 0.5
            containerMenu?.layer.cornerRadius = 5.0
            containerMenu?.layer.borderColor = UIColor.black.cgColor
            self.containerMenu.backgroundColor = UIColor.black
       isShowingMenu = true
            containerMenu.alpha = 1
        
        }
        else{
               menuButton.setImage(UIImage.init(named: "menuClosed"), for: UIControlState.normal)
             isShowingMenu = false
            menuView?.removeFromSuperview()
        }
    }
    
    func takePictures(interval:UInt64, times:UInt64 )  {
        self.timer?.invalidate()
   self.times = times
        self.timer = Timer(timeInterval: 3.0, target: self, selector: #selector(CameraViewController.takePictureAndDecreasetime), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer!, forMode: RunLoopMode.commonModes)
    }

    func takePictureAndDecreasetime()  {
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
        showbordersAfterTakingPicture(show: true)
       
        self.takepicture(UIButton())
      
     showbordersAfterTakingPicture(show: false)
//
        if self.times! > 0 {
            self.times =    self.times! - 1
            
        }
        else{
            self.times = 0
            self.timer?.invalidate()
               menuButton.setImage(UIImage.init(named: "menuClosed"), for: UIControlState.normal)
        }
          self.fetchPhotos()
    }
    
    //MARK:Delegate
    func startTakingPictures(interval:UInt64, times:UInt64 ){
      
        self.takePictures(interval: interval, times: times)
     
     
        isShowingMenu = false
        menuView?.removeFromSuperview()
        canStop = true
        
        menuButton.setImage(UIImage.init(named: "menuStop"), for: UIControlState.normal)
        containerMenu.alpha = 0
        
    }
    
    @IBAction func singleCameraAction(_ sender: UIButton) {
        showbordersAfterTakingPicture(show: true)
        self.takepicture(UIButton())
        menuButton.setImage(UIImage.init(named: "menuClosed"), for: UIControlState.normal)
     
        showbordersAfterTakingPicture(show: false)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // your function here
          self.fetchPhotos()
        ////print("MADE it to Photos")
//        }
        
    }
    @IBAction func gotoAllPhotos(_ sender: AnyObject) {
        let gridAsset = AssetGridViewController.instantiate()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(gridAsset, animated: true)
    }

 func goPro(_ sender: AnyObject) {
    
    performSegue(withIdentifier: "gotoMoney", sender: nil)
}

    @IBAction func showMeISOOptions(_ sender: AnyObject) {//
        
        if !isoSettingsOpen{
             containerMenu.alpha = 1
               if let device = captureDevice {
                iSOOptions = ISOOptionsView.instantiate(device:device)
                iSOOptions?.frame = containerMenu.frame
                 iSOOptions?.frame = CGRect.init(x: 0, y: 0, width: (iSOOptions?.frame.size.width)!, height:  (iSOOptions?.frame.size.height)!)
                
                iSOOptions?.delegate = self
                self.containerMenu.addSubview(iSOOptions!)
                self.closeMenu()
                
         containerMenu.alpha = 1
            isoSettingsOpen = true
         
            }}
        else{
            isoSettingsOpen = false
            iSOOptions?.removeFromSuperview()
            self.containerMenu.backgroundColor = UIColor.clear
            containerMenu.alpha = 0
            
        }
        
        
    }
    func closeISO()  {
        isoSettingsOpen = false
        iSOOptions?.removeFromSuperview()
              containerMenu.alpha = 0
    }
    func closeMenu()  {
        self.containerMenu.backgroundColor = UIColor.clear
        containerMenu.alpha = 0
       
        menuButton.setImage(UIImage.init(named: "menuClosed"), for: UIControlState.normal)
        isShowingMenu = false
        menuView?.removeFromSuperview()
    }
    

    
        
//        let nav = UINavigationController(rootViewController: ISOOptions)
//        nav.view.backgroundColor = UIColor.clear
//        ISOOptions.view.backgroundColor = UIColor.clear
//        nav.modalPresentationStyle = UIModalPresentationStyle.currentContext
//        ISOOptions.modalPresentationStyle = UIModalPresentationStyle.currentContext
//        
//        self.navigationController?.present(nav, animated: true, completion:nil )
    func reset() {
        let device = captureDevice
            do{
           
                try device?.lockForConfiguration()
                device?.focusMode = .continuousAutoFocus
                device?.setExposureModeCustomWithDuration(ISOHelper.sharedInstance.defaultTime!, iso: ISOHelper.sharedInstance.defaultISO!, completionHandler: { (howmuch) in
                    ////print("did set ios")
                })

            
            }
            catch{
                
            }
            
            
            device?.unlockForConfiguration()
            //                captureSession.startRunning()
             self.closeISO()
            
        
        
    }

    
    //MARK: Delegate clal back from blah
    func updatethings(timeSend: CGFloat, iSO: CGFloat, close:Bool){
            //print("setting iso time to ", timeSend , iSO)
       
            
        
       
            // update curreent device to this
            
//            captureSession.stopRunning()
            if let device = captureDevice {
                do{
                    let preferredTimeScale : Int32 = 0
                    let timeDuration : CMTime = CMTimeMakeWithSeconds(Float64(timeSend), preferredTimeScale)
                    //print("time duration was " ,timeDuration)
                    
                    
                    
                    
                    ISOHelper.sharedInstance.currentISO = Float( iSO)
                    ISOHelper.sharedInstance.currentValueISOPResent = true
                    
               
                    
                    try device.lockForConfiguration()
                    device.focusMode = .continuousAutoFocus
                      
                                    device.setExposureModeCustomWithDuration(timeDuration, iso: Float(iSO), completionHandler: { (howmuch) in
                                        ////print("did set ios")
                                    })
                }
                catch{
                    
                }
                
                
                device.unlockForConfiguration()
//                captureSession.startRunning()
                if close {
                        self.closeISO()
                }
                
            }

        }
        
    }



