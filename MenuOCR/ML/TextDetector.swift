//
//  TextDetector.swift
//  VisionSample
//
//  Created by Mohssen Fathi on 6/27/17.
//  Copyright © 2017 mohssenfathi. All rights reserved.
//

import AVFoundation
import Vision

struct TextDetector: VisionBase {
    
    private static var shared = TextDetector()
    
    static func detectText(in sampleBuffer: CMSampleBuffer, completion: @escaping ([VNTextObservation]) -> ()) {
        
        let request = VNDetectTextRectanglesRequest { (request, error) in
            guard error == nil, let results = request.results as? [VNTextObservation] else {
                    completion([])
                    return
            }
            
            completion(results)
        }
        request.reportCharacterBoxes = true
        
        do {
            try shared.perform(request: request, with: sampleBuffer)
        }
        catch {
            completion([])
        }
        
        
    }
    
}
