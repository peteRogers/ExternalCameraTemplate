//
//  VisionAnalyser.swift
//  ExternalCameraTemplate
//
//  Created by Peter Rogers on 04/06/2024.
//

import Foundation
import Vision

class VisionAnalyser{
	
	var requests = [VNRequest]()
	private weak var cm: CameraModel?
	
	init(cm: CameraModel){
		self.cm = cm
		let textDetectionRequest = VNDetectTextRectanglesRequest(completionHandler: self.handleTextDetection)
		//textDetectionRequest.reportCharacterBoxes = true // Enable detection of individual character boxes
		requests = [textDetectionRequest]
		
	}
	
	func makeAnalysis(imageBuffer: CVImageBuffer){
		var requestOptions: [VNImageOption: Any] = [:]
		
		if let cameraData = CMGetAttachment(imageBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil) {
			requestOptions = [.cameraIntrinsics: cameraData]
		}
		let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: imageBuffer, orientation: .up, options: requestOptions)
		do {
			try imageRequestHandler.perform(self.requests)
		} catch {
			print(error)
		}
	}
	
	func handleTextDetection(request: VNRequest, error: Error?) {
		guard let observations = request.results as? [VNTextObservation] else { return }
		//print(observations)
		var results:[AnalysisResult] = []
		for o in observations{
			let a = AnalysisResult(resultTotal: 0, rect: o.boundingBox)
			results.append(a)
		}
		if(results.count > 0){
			cm?.driveObservation(result: results)
		}
	}
	
	
}

struct AnalysisResult{
	var resultTotal:Int = 0
	var rect:CGRect?
	var convertedCenterPoint:CGPoint?
	
	init(resultTotal: Int, rect: CGRect? = nil) {
		self.resultTotal = resultTotal
		self.rect = rect
	}
	
	mutating func setConvertedCentrePoint(p:CGPoint){
		self.convertedCenterPoint = p
	}
	
}
