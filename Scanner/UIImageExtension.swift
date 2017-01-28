//
//  UIImageExtension.swift
//  Scanner
//
//  Created by isBSO on 9/23/16.
//  Copyright © 2016 S. All rights reserved.
//

import UIKit

extension UIImage {
    func correctlyOrientedImage() -> UIImage {
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
            self.draw(in:  CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
            let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
            UIGraphicsEndImageContext();
            return normalizedImage
        default:
           return self
        }
       
        
        
        
    }

}
extension UIImageView {
    
    
    
    func cropToBounds(_ image: UIImage, width: Double, height: Double) -> UIImage {
        
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = (contextImage.cgImage)!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    
}

