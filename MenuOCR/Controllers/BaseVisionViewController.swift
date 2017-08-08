//
//  BaseVisionViewController.swift
//  CoreMLTest
//
//  Created by Mohssen Fathi on 6/26/17.
//  Copyright © 2017 Mohssen Fathi. All rights reserved.
//

import UIKit
import AVFoundation


class BaseVisionViewController: UIViewController {
    
    let camera = Camera()
    var annotations = [CAShapeLayer]()
    var annotationContainer: UIView!
    var annotationTextContainer: UIView!
    var annotationCount: Int { return 0 }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupAnnotations()
    }
    
    func flip() {
        camera.flip()
    }
    
    func didOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer) {
        // Subclass
    }
    
    private func setupView() {
        
        // Camera
        camera.previewLayer.frame = view.bounds
        view.layer.insertSublayer(camera.previewLayer, at: 0)
        camera.position = .back
        camera.sampleBufferDelegate = self
        
        // Annotations
        annotationContainer = UIView(frame: camera.previewLayer.frame)
        annotationContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(annotationContainer)
        
        //text annotation
        annotationTextContainer = UIView(frame: camera.previewLayer.frame)
        annotationTextContainer.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(annotationTextContainer)
        
    }
    
}


// Mark: Real Time translate
extension BaseVisionViewController{

}


// MARK: - Annotations
extension BaseVisionViewController {
    
    private func setupAnnotations() {
        
        for annotation in annotations { annotation.removeFromSuperlayer() }
        
        for _ in 0 ..< annotationCount {
            addAnnotation(with: nil)
        }
    }
    
    func addAnnotation(with path: UIBezierPath?) {
        
        let layer = annotation
        annotations.append(layer)
        annotationContainer.layer.addSublayer(layer)
        
        if let path = path {
            layer.path = path.cgPath
        }
    }
    
    
    var annotation: CAShapeLayer {
        let layer = CAShapeLayer()
        layer.frame = annotationContainer.bounds
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.red.cgColor
        layer.lineWidth = 1.0
        return layer
    }
    
    func addTextTo(view: UIView, text: String, frame: CGRect){
        let label = UILabel(frame:frame)
        label.font = UIFont(name: "Helvetica-Bold", size: 10)
        label.text = text
        label.textColor = UIColor.cyan
        label.textAlignment = .center
        view.addSubview(label)
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    
    func updateAnnotations(with paths: [UIBezierPath]) {
        
        if paths.count > annotations.count {
            for i in 0 ..< paths.count {
                if i < annotations.count {
                    annotations[i].path = paths[i].cgPath
                } else {
                    addAnnotation(with: paths[i])
                }
            }
        }
        else {
            for i in 0 ..< annotations.count {
                if i < paths.count {
                    annotations[i].path = paths[i].cgPath
                } else {
                    annotations[i].path = nil
                }
                
            }
        }
    }
    
    func resetAnnotations() {
        for annotation in annotations {
            annotation.removeFromSuperlayer()
        }
        annotations.removeAll()
    }
    
}

extension BaseVisionViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        didOutput(output, didOutput: sampleBuffer)
    }
}



