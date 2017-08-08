//
//  OCR.swift
//  MenuOCR
//
//  Created by Evilisn on 8/Aug/2017.
//  Copyright © 2017 EvilisnJ. All rights reserved.
//

import Foundation
import UIKit
import TesseractOCR

class OCRPharser: NSObject,G8TesseractDelegate {
    
    private static var shared = OCRPharser()
    static let PROCESSER_INFO = ProcessInfo();//
    
    static let queue = OperationQueue()
    
    override init() {
        OCRPharser.queue.maxConcurrentOperationCount = OCRPharser.PROCESSER_INFO.processorCount * 2
    }
    
    static func detectText(taxtareas: [UIImage], completion: @escaping ([String]) -> ()) {
        for item in taxtareas{
            //Create recognitionOperation
            let operation: G8RecognitionOperation = G8RecognitionOperation(language: "eng+chi_sim")
            operation.tesseract.image = item
            operation.recognitionCompleteBlock = { (recognizedTesseract: G8Tesseract!) -> Void in
                print(recognizedTesseract.recognizedText)
            }
            OCRPharser.queue.addOperation(operation)
        }
    }
}
