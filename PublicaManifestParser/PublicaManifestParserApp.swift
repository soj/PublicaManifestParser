//
//  PublicaManifestParserApp.swift
//  PublicaManifestParser
//
//  Created by Sergey Mingalev on 21.05.2025.
//

import SwiftUI

@main
struct PublicaManifestParserApp: App {

    @StateObject private var viewModel = ManifestViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
