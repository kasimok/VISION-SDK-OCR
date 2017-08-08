//
//  TextDetectorViewController.swift
//  VisionSample
//
//  Created by Mohssen Fathi on 6/27/17.
//  Copyright © 2017 mohssenfathi. All rights reserved.
//

import UIKit
import Vision
import AVFoundation
import MarqueeLabel

class TextDetectorViewController: BaseVisionViewController {
    
    
    @IBOutlet var labelWrapperView: UIView!
    
    var hintLabel:MarqueeLabel!
    
    
    var ROIs: [CGRect]?//region of interests
    var ROIResult: [UIImage]?
    var rawImage: CIImage?
    var bStopParsing = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        camera.position = .back
        
        setupDebugLable()
        hintLabel.text = String(format:"Vision SDK Version Number: %.1f",VNVisionVersionNumber)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToOCR)))
    }
    
    override func didOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer) {
        super.didOutput(output, didOutput: sampleBuffer)
        if !bStopParsing{
            TextDetector.detectText(in: sampleBuffer) { results in
                
                DispatchQueue.main.async {
                    self.hintLabel.text = String(format:"%d feature  rects detected in camera frame",results.count)
                    self.ROIs = [CGRect]()
                    let paths = results.map { observation -> UIBezierPath in
                        
                        let imageRect = self.camera.previewLayer.frame
                        let w = observation.boundingBox.size.width * imageRect.width
                        let h = observation.boundingBox.size.height * imageRect.height
                        let x = observation.boundingBox.origin.x * imageRect.width + imageRect.origin.x
                        let y = imageRect.maxY - (observation.boundingBox.origin.y * imageRect.height) - h
                        let rect =  CGRect(x: x, y: y, width: w, height: h)
                        self.ROIs!.append(rect)
                        return UIBezierPath(rect: CGRect(x: x, y: y, width: w, height: h))
                    }
                    self.updateAnnotations(with: paths)
                    self.rawImage = CIImage(CMSampleBuffer: sampleBuffer)
                    
                }
            }
            
        }
        
    }
}


//set up debugging area
extension TextDetectorViewController{
    func setupDebugLable(){
        hintLabel = MarqueeLabel(frame: labelWrapperView.bounds, duration: 7.0, fadeLength: 0)
        hintLabel.font = UIFont.systemFont(ofSize: 13)
        hintLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        labelWrapperView.addSubview(hintLabel)
    }
}

extension TextDetectorViewController{
    @objc func goToOCR(){
        guard let ci = self.rawImage else {
            return
        }
        guard let rois = self.ROIs, rois.count>0 else {
            hintLabel.text = "No Text detected..."
            return
        }
        
        bStopParsing = true
        self.ROIResult = [UIImage]()
        //1. crop and rotate the images
        let factor:CGFloat = 1080/UIScreen.main.bounds.width
        let raw:UIImage = convert(cmage: ci)
        for roi in rois{
            let roiZoom = CGRect(x: roi.minX * factor, y: roi.minY * factor, width: roi.width * factor, height: roi.height * factor)
            let cropped = raw.crop(rect: roiZoom)
            let _ = cropped.cgImage
            self.ROIResult?.append(cropped)
            
        }
        hintLabel.text = String(format:"Cropped %d images to memory",self.ROIResult!.count)
        performSegue(withIdentifier: "ocr", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! OCRViewController
        dest.results = self.ROIResult!
    }
}



