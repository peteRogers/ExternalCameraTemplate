//
//  SkeletonsView.swift
//  Vision_swiftUI_Boiler
//
//  Created by Peter Rogers on 02/05/2024.
//

import SwiftUI

struct SkeletonsView: View {
	//let skeletons: [MySkeleton]
	let skeletons: [AnalysisResult]
    var body: some View {
		Canvas { context, size in
			for skeleton in skeletons{
				//print(context.clipBoundingRect)
				//let p = PointsOverlay(with: skeleton)
				if let p = skeleton.convertedCenterPoint{
					var c = Circle().path(in: CGRect(x: p.x, y: p.y, width: 10, height: 10))
					context.fill(c, with: .color(.red))
				}
			}
		}
//		Canvas(
//			opaque: true,
//			colorMode: .linear,
//			rendersAsynchronously: false
//		) { context, size in
//			let rect = CGRect(origin: .zero, size: size)
//			for skeleton in skeletons{
//				
//			}
//			
//			var path = Circle().path(in: rect)
//			context.fill(path, with: .color(.red))
//		}
    }
}

//#Preview {
//	//SkeletonsView(skeletons:[])
//}
