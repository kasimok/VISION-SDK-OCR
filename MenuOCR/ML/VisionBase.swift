//
//  VisionBase.swift
//  CoreMLTest
//
//  Created by Mohssen Fathi on 6/21/17.
//  Copyright © 2017 Mohssen Fathi. All rights reserved.
//

import Vision
import AVFoundation

protocol VisionBase {
    func perform(request: VNRequest, with sampleBuffer: CMSampleBuffer, isSequence: Bool) throws
    func perform(request: VNRequest, with image: CIImage) throws
}

fileprivate var sequenceHandler = VNSequenceRequestHandler()

extension VisionBase {
    
    func perform(request: VNRequest, with sampleBuffer: CMSampleBuffer, isSequence: Bool = false) throws {
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            throw VisionError.invalidSampleBuffer
        }
        
        if isSequence {
            do {
                try sequenceHandler.perform([request], on: pixelBuffer)
            } catch {
                print(error.localizedDescription)
                throw VisionError.unknown
            }
            return
        }
        
        var options: [VNImageOption: Any] = [:]
        if let cameraIntrinsicData = CMGetAttachment(sampleBuffer, kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, nil) {
            options = [.cameraIntrinsics: cameraIntrinsicData]
        }
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right, options: options)
        
        do {
            try handler.perform([request])
        } catch {
            print(error.localizedDescription)
            throw VisionError.unknown
        }
    }
    
    
    
    func perform(request: VNRequest, with image: CIImage) throws {
        
        let options: [VNImageOption: Any] = [:]
        let handler = VNImageRequestHandler(ciImage: image, options: options)
        
        do {
            try handler.perform([request])
        } catch {
            print(error.localizedDescription)
            throw VisionError.unknown
        }
    }
    
}

enum VisionError: Error {
    case invalidSampleBuffer
    case unknown
}
