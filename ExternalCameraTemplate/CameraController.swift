//
//  CameraController.swift
//  macos_external_camera
//
//  Created by Peter Rogers on 03/03/2023.
//

import Cocoa
import SwiftUI
import AVFoundation
import Vision

class CameraController: NSViewController, AVCaptureVideoDataOutputSampleBufferDelegate  {
   
    weak var delegate:CameraControllerDelegate?
	weak var cm:CameraModel?
    private let sequenceHandler = VNSequenceRequestHandler()
    private let videoDataOutputQueue = DispatchQueue(
        label: "CameraFeedOutput",
        qos: .userInteractive
    )
    private var cameraFeedSession: AVCaptureSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
       
        view = NSView(frame: NSMakeRect(0.0, 0.0, 10, 10))
        view.wantsLayer = true
    
       }
    
    
    override func viewDidAppear() {
        super.viewDidAppear()
        do {
            if cameraFeedSession == nil {
                try setupAVSession()
                let playerLayer = AVCaptureVideoPreviewLayer(session: cameraFeedSession!)
                self.view.layer = playerLayer
				cm?.setPreviewLayer(layer: playerLayer)
//                if (cameraView.previewLayer.connection!.isVideoMirroringSupported) {
//                    print("Is supported mirroring")
//                    cameraView.previewLayer.connection!.automaticallyAdjustsVideoMirroring = false
//                    cameraView.previewLayer.connection!.isVideoMirrored = false
//                }
                //cameraView.previewLayer.videoGravity = .resizeAspect
                
            }
            DispatchQueue.global(qos: .userInitiated).async{
                self.cameraFeedSession?.startRunning()
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func setupAVSession() throws {
        
        // Select a front facing camera, make an input.
       
        guard let videoDevice = AVCaptureDevice.default(
			.external,
            for: .video,
            position: .front)
        else {
            throw AppError.captureSessionSetup(
                reason: "Could not find a front facing camera."
            )
        }
        
        guard let deviceInput = try? AVCaptureDeviceInput(
            device: videoDevice
        ) else {
            throw AppError.captureSessionSetup(
                reason: "Could not create video device input."
            )
        }
        
        let session = AVCaptureSession()
        session.beginConfiguration()
        
        session.sessionPreset = AVCaptureSession.Preset.high
        
        
        // Add a video input.
        guard session.canAddInput(deviceInput) else {
            throw AppError.captureSessionSetup(
                reason: "Could not add video device input to the session"
            )
        }
        session.addInput(deviceInput)
        
        
        let dataOutput = AVCaptureVideoDataOutput()
        
        if session.canAddOutput(dataOutput) {
            session.addOutput(dataOutput)
            // Add a video data output.
            dataOutput.alwaysDiscardsLateVideoFrames = true
            dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            throw AppError.captureSessionSetup(
                reason: "Could not add video data output to the session"
            )
        }
        session.commitConfiguration()
        cameraFeedSession = session
        
    }
    override func viewDidLayout() {
        print("view layed out")
        print(view.frame.debugDescription)
		//cm?.setPreviewLayer(layer: view.layer)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer,from connection: AVCaptureConnection) {
        
       

//                counter += 1
//        if(counter > 2){
//            counter = 0
            guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                debugPrint("unable to get image from sample buffer")
//				AppError.captureSessionSetup(
//					reason: "Could not add video data output to the session"
//				)
				return
            }
		
		cm?.doObservation(imageBuffer: frame)


        }
  //  }
}

protocol CameraControllerDelegate:AnyObject {
    func cameraView(_ cameraView:CameraController)
}


struct CameraView: NSViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
   
    //var score: (([VNBarcodeObservation]) -> Void)?
	var model: CameraModel
	
    class Coordinator: NSObject, CameraControllerDelegate {
       
        func cameraView(_ cameraView: CameraController) {
            self.parent.presentationMode.wrappedValue.dismiss()
		}
        
        var parent: CameraView
		var model:CameraModel

		init(_ parent: CameraView, model:CameraModel) {
            self.parent = parent
			self.model = model
        }
        
       
    }
    
    
    func makeNSViewController(context: Context) -> NSViewController {
        let cvc = CameraController()
		cvc.cm = model
       // cvc.score = score
        return cvc
        }

        func updateNSViewController(_ uiViewController: NSViewController, context: Context) {
        }
    func makeCoordinator() -> Coordinator {
		Coordinator(self, model:model)
    }
}
