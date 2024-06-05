//
//  CameraModel.swift
//  ExternalCameraTemplate
//
//  Created by Peter Rogers on 04/06/2024.
//

import Foundation
import AVFoundation

@Observable class CameraModel{
	
	//private weak var previewView:
	private weak var previewView:AVCaptureVideoPreviewLayer?
	
	var observations:[AnalysisResult] = []
	
	init(){
		
	}
	
	func setPreviewLayer(layer:AVCaptureVideoPreviewLayer){
		print("preview layer in model size \(layer.frame)")
		self.previewView = layer
	}
	
	func doObservation(imageBuffer: CVImageBuffer){
		let va = VisionAnalyser(cm: self)
		va.makeAnalysis(imageBuffer: imageBuffer)
		
		
	}
	
	func driveObservation(result: [AnalysisResult]){
		var convResult:[AnalysisResult] = []
		for r in result{
			if let p = r.rect{
				
				let convP = convertPointToPreview(p: CGPoint(x: p.midX, y: p.midY))
				var ar = r
				ar.setConvertedCentrePoint(p: convP)
				convResult.append(ar)
			}
		}
		self.observations = convResult
		
	}
	
	func convertPointToPreview(p: CGPoint) -> CGPoint{
		if let preview = previewView{
			print(preview.frame)
			let convertedPoint = CGPoint(
				x: p.x * preview.frame.width,
				y: (1 - p.y) * preview.frame.height
			)
			return convertedPoint
			
		}
		return p
	}
		

	
	
}
