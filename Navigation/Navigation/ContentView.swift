//
//  ContentView.swift
//  Navigation
//
//  Created by Armaan Gupta on 5/2/25.
//

import SwiftUI

struct ContentView: View {
	@State private var title = "SwiftUI"

	var body: some View {
		NavigationStack {
			Text("Hello, world!")
				.navigationTitle($title)
				.navigationBarTitleDisplayMode(.inline)
		}
	}
}

#Preview {
    ContentView()
}
