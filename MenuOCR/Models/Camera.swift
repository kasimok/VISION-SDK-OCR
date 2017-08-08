//
//  Camera.swift
//  CoreMLTest
//
//  Created by Mohssen Fathi on 6/24/17.
//  Copyright © 2017 Mohssen Fathi. All rights reserved.
//

import AVKit

class Camera: NSObject {
    
    override init() {
        super.init()
        setupCamera()
    }
    
    var position: AVCaptureDevice.Position = .back {
        didSet {
            session.beginConfiguration()
            setupInput(position: position)
            session.commitConfiguration()
        }
    }
    
    func flip() {
        position = (position == .back) ? .front : .back//
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var sampleBufferDelegate: AVCaptureVideoDataOutputSampleBufferDelegate? {
        didSet {
            guard let delegate = sampleBufferDelegate else { return }
            output.setSampleBufferDelegate(delegate, queue: DispatchQueue(label: "dataOutput"))
        }
    }
    
    private var session: AVCaptureSession!
    private var device: AVCaptureDevice!
    private var input: AVCaptureDeviceInput!
    private var output: AVCaptureVideoDataOutput!
}


// MARK: - Camera Setup
extension Camera {
    
    func setupCamera() {
        
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSession.Preset.high
        
        setupInput(position: .back)
        setupOutput()
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        
        session.startRunning()
    }
    
    func setupInput(position: AVCaptureDevice.Position) {
        
        for inp in session.inputs { session.removeInput(inp) }
//        device = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: .video, position: position) //hell xcode 9 beta 4 breaks on this line.  roll apple!'
        
        device  = AVCaptureDevice.default(for: .video)
        guard let inp = try? AVCaptureDeviceInput(device: device) else { fatalError("No inputs") }
        input = inp
        
        if session.canAddInput(input) { session.addInput(input) }
    }
    
    func setupOutput() {
        
        for out in session.outputs { session.removeOutput(out) }
        
        output = AVCaptureVideoDataOutput()
        output.connection(with: .video)?.videoOrientation = .portrait
        
        if session.canAddOutput(output) { session.addOutput(output) }
    }
    
}

