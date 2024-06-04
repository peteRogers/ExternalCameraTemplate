//
//  ContentView.swift
//  ExternalCameraTemplate
//
//  Created by Peter Rogers on 04/06/2024.
//

import SwiftUI

struct ContentView: View {
	var cm = CameraModel()
    var body: some View {
		VStack {
			
			CameraView( model: cm)
				.overlay{
					SkeletonsView(skeletons: cm.observations)
					
				}
		}
    }
}

#Preview {
    ContentView()
}
