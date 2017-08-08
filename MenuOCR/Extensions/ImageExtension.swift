

//
//  ImageExtension.swift
//  MenuOCR
//
//  Created by Evilisn on 3/Aug/2017.
//  Copyright © 2017 EvilisnJ. All rights reserved.
//

import Foundation
import UIKit



extension UIImage {
    func crop( rect: CGRect) -> UIImage {
        let imageRef:CGImage = self.cgImage!.cropping(to: rect)!
        let cropped:UIImage = UIImage(cgImage:imageRef)
        return cropped
    }
    
}
