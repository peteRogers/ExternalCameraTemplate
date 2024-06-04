
import SwiftUI
import Vision

struct PointsOverlay: Shape {
  let observation: AnalysisResult
  
  init(with observations: AnalysisResult) {
    self.observation = observations
  }

  func path(in rect: CGRect) -> Path {
	var pointsPath = Path()
   // for joint in observations {
	  if let p = observation.rect{
		  print(p.debugDescription)
		  pointsPath.move(to:CGPoint(x: 0, y: 0))
		  pointsPath.addLine(to: CGPoint(x: 100, y: 100))
		 
		 
		  
		 
		 // pointsPath.addArc(withCenter: p, radius: 15, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
		  //			if let ip = joint.imagePoint{
		  //				pointsPath.move(to: ip)
		  //				pointsPath.addArc(withCenter: ip, radius: 15, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
		  //
		  //
		  //		}
	  }

    return Path(pointsPath.cgPath)
  }
}
