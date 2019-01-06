//
//  takePicture.swift
//  ImageRunner
//
//  Created by William Schneider on 1/6/19.
//  Copyright © 2019 William Schneider. All rights reserved.
//

import UIKit
import AVFoundation

class takePicture: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let captureSession = AVCaptureSession()
    var previewLayer:CALayer!
    
    var captureDevice:AVCaptureDevice!
    
    var takePhoto = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCamera()

        // Do any additional setup after loading the view.
    }
    
    func prepareCamera(){
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        let availible = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
        captureDevice = availible
        beginSession()
    }
    
    func beginSession(){
        do{
            let capture = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(capture)
        }catch{
            print(error.localizedDescription)
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.frame = view.frame
        self.view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
        
        let dataOut = AVCaptureVideoDataOutput()
        dataOut.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString):NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        
        dataOut.alwaysDiscardsLateVideoFrames = true
        
        if(captureSession.canAddOutput(dataOut)){
            captureSession.addOutput(dataOut)
        }
        
        captureSession.commitConfiguration()
        
        let que = DispatchQueue(label: "will.pic")
        dataOut.setSampleBufferDelegate(self, queue: que)
        
        
    }
    
    @IBAction func takePic(_ sender: Any) {
        takePhoto = true
    }
    
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if takePhoto{
            takePhoto = false
            let image = getImageBuffer(buffer: sampleBuffer)
//
//            let url = NSURL(string: "https://imagerunner.localtunnel.me")
//            let request: NSMutableURLRequest = NSMutableURLRequest(url: <#T##URL#>)
//            request.httpMethod = "POST"
//            let data = NSData("")
//            let boundary = generateBoundary()
//            let data = photoDataToFormData(data, boundary, fileName)
            
            self.performSegue(withIdentifier: "camera2Output", sender: self)
            
            
        }
    }
    
    func getImageBuffer(buffer: CMSampleBuffer) -> UIImage?{
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer){
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()
            
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            
            if let image = context.createCGImage(ciImage, from: imageRect){
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
        }
        return nil
    }
    
}
