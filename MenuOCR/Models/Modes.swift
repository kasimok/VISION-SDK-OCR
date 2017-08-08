//
//  Modes.swift
//  CoreMLTest
//
//  Created by Mohssen Fathi on 6/26/17.
//  Copyright © 2017 Mohssen Fathi. All rights reserved.
//

import Foundation

enum Mode: Int {
    case classifier
    case faceLines
    case faceMask
    case objectTracking
    case textDetector
    
    var title: String {
        switch self {
        case .classifier:       return "Classifier"
        case .faceLines:        return "Face Landmark Detection"
        case .faceMask:         return "Mask"
        case .objectTracking:   return "Object Tracking"
        case .textDetector:     return "Text Detection"
        }
    }
    
    var identifier: String {
        switch self {
        case .classifier:       return "Classifier"
        case .faceLines:        return "FaceLines"
        case .faceMask:         return "FaceMask"
        case .objectTracking:   return "ObjectTracker"
        case .textDetector:     return "TextDetector"
        }
    }
    
//    var description: String {
//        switch self {
//        case .classifier:       return "Classify objects using the InceptionV3 pre-trained model"
//        case .faceLines:        return "Details face landmarks by showing face contours"
//        case .faceMask:         return "Overlays 3D model mask over face using face landmarks"
//        case .objectTracking:   return "Tap an object to start tracking"
//        }
//    }
    
    static var allModes: [Mode] {
        return [.classifier, .faceLines, .faceMask, .objectTracking, .textDetector]
    }
}
