//
//  ExternalCameraTemplateApp.swift
//  ExternalCameraTemplate
//
//  Created by Peter Rogers on 04/06/2024.
//

import SwiftUI

@main
struct ExternalCameraTemplateApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView()
				.onDisappear{
					terminateApp()
				}
		}
	}
	
	private func terminateApp() {
		   NSApplication.shared.terminate(self)
	   }
}
